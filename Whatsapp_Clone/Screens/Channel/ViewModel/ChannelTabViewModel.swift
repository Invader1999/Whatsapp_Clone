//
//  ChannelTabViewModel.swift
//  Whatsapp_Clone
//
//  Created by Kareddy Hemanth Reddy on 11/05/24.
//

import Foundation
import Observation
import Firebase

enum ChannelTabRoutes:Hashable{
    case chatRoom(_ channel:ChannelItem)
}


final class ChannelTabViewModel:ObservableObject{
    
    @Published var navigationRoutes = [ChannelTabRoutes]()
    @Published var navigateToChatRoom = false
    @Published var newChannel:ChannelItem?
    @Published  var showChatPartnerPickerView = false
    @Published var channels = [ChannelItem]()
    
    typealias ChannelId = String
    @Published var channelDictionary:[ChannelId:ChannelItem] = [:]
    
    private let currentUser:UserItem
    init(_ currentUser:UserItem){
        self.currentUser = currentUser
        fetchCurrentUserChannel()
    }
    
    func onNewChannelCreation(_ channel:ChannelItem){
        showChatPartnerPickerView = false
        newChannel = channel
        navigateToChatRoom = true
    }
    
    private func fetchCurrentUserChannel(){
        guard let curentUid = Auth.auth().currentUser?.uid else {return}
        FirebaseConstants.UserChannelsRef.child(curentUid).observe(.value) {[weak self] snapshot in
            guard let dict = snapshot.value as? [String:Any] else{return}
            dict.forEach { key,value in
                let channelId = key
                self?.getChannel(with: channelId)
            }
        } withCancel: { error in
            print("Failed to get users channel's IDs:\(error.localizedDescription)")
        }
        
    }
    
    private func getChannel(with channelId:String){
        FirebaseConstants.ChannelsRef.child(channelId).observe(.value) {[weak self] snapshot in
            guard let dict = snapshot.value as? [String:Any], let self = self else{return}
            var channel = ChannelItem(dict)
            self.getChannelMembers(channel){ members in
                channel.members = members
                
                channel.members.append(self.currentUser)
                
                self.channelDictionary[channelId] = channel
                self.reloadData()
                //                self?.channels.append(channel)
                print("channel \(channel.title)")
            }
        }withCancel: { error in
            print("Failed to get channel for  id \(channelId):\(error.localizedDescription)")
        }
    }
    
    private func getChannelMembers(_ channel: ChannelItem,completion: @escaping (_ members:[UserItem])->Void){
        guard let curentUid = Auth.auth().currentUser?.uid else {return}
        let channelMembersUids = Array(channel.membersUids.filter{$0 != curentUid}.prefix(2))
        UserService.getUsers(with: channelMembersUids) { userNode in
            completion(userNode.users)
        }
    }
    
    private func reloadData(){
        self.channels = Array(channelDictionary.values)
        self.channels.sort{$0.lastMessageTimeStamp > $1.lastMessageTimeStamp}
    }
}
