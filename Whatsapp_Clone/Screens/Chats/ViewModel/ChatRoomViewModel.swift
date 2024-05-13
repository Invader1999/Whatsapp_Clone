//
//  ChatRoomViewModel.swift
//  Whatsapp_Clone
//
//  Created by Kareddy Hemanth Reddy on 13/05/24.
//

import Combine
import Foundation
import Observation

@Observable
final class ChatRoomViewModel {
    var textMessage: String = ""
    private let channel: ChannelItem
    
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
        AuthManager.shared.authState.receive(on: DispatchQueue.main).sink { authState in
            switch authState {
            case .loggedIn(let currentUser):
                self.currentUser = currentUser
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
}
