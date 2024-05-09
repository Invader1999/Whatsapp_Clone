//
//  ChatPartnerPickerViewModel.swift
//  Whatsapp_Clone
//
//  Created by Kareddy Hemanth Reddy on 09/05/24.
//

import Foundation
import Observation

enum ChannelCreationRoute{
    case addGroupChatMembers
    case setupGroupChat
}

@Observable
final class ChatPartnerPickerViewModel{
    var navStaack = [ChannelCreationRoute]()
    var selectedChatPartners = [UserItem]()
    
    var showSelectedUsers:Bool{
        return !selectedChatPartners.isEmpty
    }
    
    
    //MARK: - Public Methods
    func handleItemSelection(_ item:UserItem){
        if isUserSelected(item){
            guard let index = selectedChatPartners.firstIndex(where: { $0.uid == item.uid }) else {return}
            selectedChatPartners.remove(at: index)
        }else{
            selectedChatPartners.append(item)
        }
    }
    
    func isUserSelected(_ user:UserItem) -> Bool{
        let isSelected = selectedChatPartners.contains{ $0.uid == user.uid}
        return isSelected
    }
}
