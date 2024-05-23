//
//  ChatRoomViewModel.swift
//  Whatsapp_Clone
//
//  Created by Kareddy Hemanth Reddy on 13/05/24.
//

import Combine
import Foundation
//import Observation
//
//@Observable
final class ChatRoomViewModel:ObservableObject {
    
   @Published var textMessage: String = ""
    
   @Published var messages = [MessageItem]()
    
    private(set) var channel: ChannelItem
    
    private var subscriptions = Set<AnyCancellable>()
    
    var currentUser:UserItem?
    
    init(_ channel: ChannelItem) {
        self.channel = channel
        listenToAuthState()
    }
    
    deinit{
        subscriptions.forEach{$0.cancel()}
        subscriptions.removeAll()
        currentUser = nil
    }
    
    private func listenToAuthState() {
        AuthManager.shared.authState.receive(on: DispatchQueue.main).sink {[weak self] authState in
            guard let self = self else {return}
            switch authState {
            case .loggedIn(let currentUser):
                self.currentUser = currentUser
                if self.channel.allMembersFetched{
                    self.getMessages()
                    print("channel members: \(channel.members.map{$0.username})")
                }else{
                    self.getAllChannelMembers()
                }
            default:
                break
            }
        }.store(in: &subscriptions)
    }
    
    func sendMessage() {
        guard let currentUser else{ return }
        MessageService.sendTextMessage(to: channel, from: currentUser, textMessage) {[weak self] in
            self?.textMessage = ""
        }
    }
    
    private func getMessages(){
        MessageService.getMessages(for: channel) {[weak self] messages in
            self?.messages = messages
            print("messages: \(messages.map{$0.text})")
        }
    }
    
    private func getAllChannelMembers(){
        guard let currentUser = currentUser else {return}
        let memebersAlreadyFetched = channel.members.compactMap{$0.uid}
        var memberUIDSToFetch = channel.membersUids.filter{!memebersAlreadyFetched.contains($0)}
        memberUIDSToFetch = memberUIDSToFetch.filter{$0 != currentUser.uid}
        
        UserService.getUsers(with: memberUIDSToFetch) { [weak self] userNode in
            guard let self = self else {return}
            self.channel.members.append(contentsOf: userNode.users)
            self.getMessages()
            print("gellAllChannelMemebers: \(channel.members.map{$0.username})")
        }
    }
}
