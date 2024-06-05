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
    
    private(set) var channel: ChannelItem
    private var subscriptions = Set<AnyCancellable>()
    var currentUser: UserItem?
    
    var showPhotosPikcerPreview: Bool {
        return !mediaAttachments.isEmpty || !photosPickerItems.isEmpty
    }
    
    init(_ channel: ChannelItem) {
        self.channel = channel
        listenToAuthState()
        onPhotoPickerSelection()
    }
    
    deinit {
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
        currentUser = nil
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
    
    func sendMessage() {
        guard let currentUser else { return }
        MessageService.sendTextMessage(to: channel, from: currentUser, textMessage) { [weak self] in
            self?.textMessage = ""
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
        }
    }
    
    private func onPhotoPickerSelection() {
        $photosPickerItems.sink { [weak self] photoItems in
            guard let self = self else { return }
            self.mediaAttachments.removeAll()
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
        }
    }
    
    
    private func remove(_ item:MediaAttachment){
        guard let attachmentIndex = mediaAttachments.firstIndex(where: {$0.id == item.id}) else {return}
        mediaAttachments.remove(at: attachmentIndex)
        
        guard let photoIndex = photosPickerItems.firstIndex(where: {$0.itemIdentifier == item.id}) else {return}
        photosPickerItems.remove(at: photoIndex)
    }
}
