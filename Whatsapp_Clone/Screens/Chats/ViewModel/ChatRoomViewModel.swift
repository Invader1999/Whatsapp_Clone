//
//  ChatRoomViewModel.swift
//  Whatsapp_Clone
//
//  Created by Kareddy Hemanth Reddy on 13/05/24.
//

import _PhotosUI_SwiftUI
import Combine
import Foundation

// import Observation
//
// @Observable
@MainActor
final class ChatRoomViewModel: ObservableObject {
    @Published var textMessage: String = ""
    @Published var messages = [MessageItem]()
    @Published var showPhotosPikcer = false
    @Published var photosPickerItems: [PhotosPickerItem] = []
    @Published var mediaAttachments: [MediaAttachment] = []
    @Published var videoPlayerState:(show:Bool,player:AVPlayer?) = (false,nil)
    @Published var isRecordingVoiceMessage = false
    @Published var elapsedVoiceMessageTime:TimeInterval = 0
    @Published var scrollToBottomRequest:(scroll:Bool,isAnimated:Bool) = (false,false)
    
    
    private(set) var channel: ChannelItem
    private var subscriptions = Set<AnyCancellable>()
    var currentUser: UserItem?
    private let voiceRecorderService = VoiceRecorderService()
    
    var showPhotosPikcerPreview: Bool {
        return !mediaAttachments.isEmpty || !photosPickerItems.isEmpty
    }
    
    var disableSendButton:Bool{
        return mediaAttachments.isEmpty && textMessage.isEmptyOrWhiteSpace
    }
    
    
    init(_ channel: ChannelItem) {
        self.channel = channel
        listenToAuthState()
        onPhotoPickerSelection()
        setUpVoiceRecorderListners()
    }
    
    deinit {
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
        currentUser = nil
        voiceRecorderService.tearDown()
    }
    
    private func listenToAuthState() {
        AuthManager.shared.authState.receive(on: DispatchQueue.main).sink { [weak self] authState in
            guard let self = self else { return }
            switch authState {
            case .loggedIn(let currentUser):
                self.currentUser = currentUser
                if self.channel.allMembersFetched {
                    self.getMessages()
                    print("channel members: \(channel.members.map { $0.username })")
                } else {
                    self.getAllChannelMembers()
                }
            default:
                break
            }
        }.store(in: &subscriptions)
    }
    
    private func setUpVoiceRecorderListners(){
        voiceRecorderService.$isRecording.receive(on: DispatchQueue.main)
            .sink { [weak self] isRecording in
                self?.isRecordingVoiceMessage = isRecording
            }
            .store(in: &subscriptions)
        
        
        voiceRecorderService.$elapsedTime.receive(on: DispatchQueue.main)
            .sink { [weak self] elapsedTime in
                self?.elapsedVoiceMessageTime = elapsedTime
            }
            .store(in: &subscriptions)
    }
    
    func sendMessage() {
        guard let currentUser else { return }
        if mediaAttachments.isEmpty{
            MessageService.sendTextMessage(to: channel, from: currentUser, textMessage) { [weak self] in
                self?.textMessage = ""
            }
        }else{
            sendMultipleMessages(textMessage, attachments: mediaAttachments)
            clearTextInputArea()
        }
    }
    
    private func clearTextInputArea(){
        mediaAttachments.removeAll()
        photosPickerItems.removeAll()
        textMessage = ""
        UIApplication.dismissKeyboard()
    }
    
    private func sendMultipleMessages(_ text:String,attachments:[MediaAttachment]){
        mediaAttachments.forEach { attachment in
            switch attachment.type {
            case .photo:
                sendPhotoMessage(text: text, attachment)
            case .video:
                break
            case .audio:
                break
            }
        }
    }
    
    private func sendPhotoMessage(text:String,_ attachment:MediaAttachment){
        
        uploadImageToStorage(attachment) {[weak self] imageUrl in
            guard let self = self, let currentUser else {return}
            print("Uploaded Image To Storage: ")
            let uploadPrams = MessageUploadParams(channel: channel, text: text, type: .photo, attachment: attachment, thumbnailURL:imageUrl.absoluteString, sender: currentUser)
            
            MessageService.sendMediaMessage(to: channel, params: uploadPrams) {[weak self] in 
                print("Uploaded Image To Database: ")
                self?.scrollToBottom(isAnimated: true)
            }
        }
        
    }
    
    private func scrollToBottom(isAnimated:Bool){
        scrollToBottomRequest.scroll = true
        scrollToBottomRequest.isAnimated = isAnimated
    }
    
    
    private func uploadImageToStorage(_ attachment:MediaAttachment, completion:@escaping(_ imageUrl:URL) -> Void){
        FirebaseHelper.uploadImage(attachment.thumbnail, for: .photoMessage) { result in
            switch result{
            case .success(let imageUrl):
                completion(imageUrl)
            case .failure(let error):
                print("Failed To Upload Image To Storage: \(error.localizedDescription)")
            }
        } progressHandler: { progress in
            print("UPLOAD IMAGE PROGRESS: \(progress)")
        }
    }
    
    private func getMessages() {
        MessageService.getMessages(for: channel) { [weak self] messages in
            self?.messages = messages
            print("messages: \(messages.map { $0.text })")
        }
    }
    
    private func getAllChannelMembers() {
        guard let currentUser = currentUser else { return }
        let memebersAlreadyFetched = channel.members.compactMap { $0.uid }
        var memberUIDSToFetch = channel.membersUids.filter { !memebersAlreadyFetched.contains($0) }
        memberUIDSToFetch = memberUIDSToFetch.filter { $0 != currentUser.uid }
        
        UserService.getUsers(with: memberUIDSToFetch) { [weak self] userNode in
            guard let self = self else { return }
            self.channel.members.append(contentsOf: userNode.users)
            self.getMessages()
            print("gellAllChannelMemebers: \(channel.members.map { $0.username })")
        }
    }
    
    func handleTextInputArea(_ action: TextInputArea.UserAction) {
        switch action {
        case .presentPhotoPicker:
            showPhotosPikcer = true
        case .sendMessage:
            sendMessage()
        case .recordAudio:
            toggleAudioRecorder()
        }
    }
    
    private func toggleAudioRecorder(){
        if voiceRecorderService.isRecording{
            voiceRecorderService.stopRecording {[weak self] audioURL, audioDuration in
                self?.createAudioAttachment(from: audioURL, audioDuration)
            }
        }else{
            voiceRecorderService.startRecording()
        }
    }
    
    
    
    private func createAudioAttachment(from audioURL:URL?,_ audioDuration:TimeInterval){
        guard let audioURL = audioURL else {return}
        let id = UUID().uuidString
        let audioAttachment = MediaAttachment(id: id, type: .audio(audioURL, audioDuration))
        mediaAttachments.insert(audioAttachment, at: 0)
    }
    
    
    private func onPhotoPickerSelection() {
        $photosPickerItems.sink { [weak self] photoItems in
            guard let self = self else { return }
            //self.mediaAttachments.removeAll()
            let audioRecordings = mediaAttachments.filter({ $0.type == .audio(.stubURL,.stubTimeInterval)})
            self.mediaAttachments = audioRecordings
            Task { await self.parsePhotoPickerItems(photoItems) }
        }
        .store(in: &subscriptions)
    }
    
    private func parsePhotoPickerItems(_ photoPickerItems: [PhotosPickerItem]) async {
        for photoItem in photoPickerItems {
            if photoItem.isVideo {
                
                if let movie = try? await photoItem.loadTransferable(type: VideoPickerTransferable.self),let thumbnailImage = try? await movie.url.generateVideoThumbnail(),let itemIdentifier = photoItem.itemIdentifier{
                    let videoAttachment = MediaAttachment(id: itemIdentifier, type: .video(thumbnailImage, movie.url))
                    self.mediaAttachments.insert(videoAttachment, at: 0)
                }
                
            } else {
                guard
                    let data = try? await photoItem.loadTransferable(type: Data.self),
                    let thumbnail = UIImage(data: data),
                    let itemIndentifier = photoItem.itemIdentifier
                else { return }
                
                let photoAttachments = MediaAttachment(id: itemIndentifier, type: .photo(thumbnail))
                self.mediaAttachments.insert(photoAttachments, at: 0)
            }
        }
    }
    
    func dismissMediaPlayer(){
        videoPlayerState.player?.replaceCurrentItem(with: nil)
        videoPlayerState.player = nil
        videoPlayerState.show = false
        
    }
    
    func showMediaPlayer(_ fileURL:URL){
        videoPlayerState.show = true
        videoPlayerState.player = AVPlayer(url: fileURL)
    }
    
    
    func handleMediaAttachmentPreview(_ action:MediaAttachmentPreview.UserAction){
        switch action {
        case .play(let attachment):
            guard let fileURL = attachment.fileURL else {return}
            showMediaPlayer(fileURL)
        case .remove(let attachment):
            remove(attachment)
            guard let fileURL = attachment.fileURL else {return}
            if attachment.type == .audio(.stubURL, .stubTimeInterval){
                voiceRecorderService.deletRecording(at: fileURL)
            }
        }
    }
    
    
    private func remove(_ item:MediaAttachment){
        guard let attachmentIndex = mediaAttachments.firstIndex(where: {$0.id == item.id}) else {return}
        mediaAttachments.remove(at: attachmentIndex)
        
        guard let photoIndex = photosPickerItems.firstIndex(where: {$0.itemIdentifier == item.id}) else {return}
        photosPickerItems.remove(at: photoIndex)
    }
}
