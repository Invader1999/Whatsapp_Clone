//
//  ChannelItem.swift
//  Whatsapp_Clone
//
//  Created by Kareddy Hemanth Reddy on 11/05/24.
//

import Foundation
import Firebase

struct ChannelItem:Identifiable,Hashable {
    var id: String
    var name: String?
    private var lastMessage: String
    var creationDate: Date
    var lastMessageTimeStamp: Date
    var membersCount: Int
    var adminUids: [String]
    var membersUids: [String]
    var members: [UserItem]
    private var thumbnailUrl: String?
    var createdBy: String
    var lastMessageType:MessageType

    var isGroupChat: Bool {
        return membersCount > 2
    }
    var coverImageUrl:String?{
        if let thumbnailUrl = thumbnailUrl{
            return thumbnailUrl
        }
        
        if isGroupChat == false{
            return membersExcludingMe.first?.profileImageUrl
        }
        
        return nil
    }
    
    var membersExcludingMe:[UserItem]{
        guard let currentUid = Auth.auth().currentUser?.uid else{return []}
        return members.filter{$0.uid != currentUid}
    }
    
    var title:String{
        if let name = name{
            return name
        }
        
        if isGroupChat{
            return groupMembersName
            
        }else{
            return membersExcludingMe.first?.username ?? "Unknown"
        }
    }
    
    private var groupMembersName:String{
        let memebersCount = membersCount - 1
        let fullNames:[String] = membersExcludingMe.map{$0.username}
        
        if memebersCount == 2 {
            return fullNames.joined(separator: " and ")
        }else if memebersCount > 2{
            let remainingCount = membersCount - 2
            return fullNames.prefix(2).joined(separator: ", ") + ", and \(remainingCount) " + "others"
        }
        return "Unkown"
    }
    
    var isCreatedByMe: Bool{
        return createdBy == Auth.auth().currentUser?.uid ?? ""
    }
    
    var creatorName:String{
        return members.first{$0.uid == createdBy}?.username ?? "Someone"
    }
    
    var allMembersFetched:Bool{
        return members.count == membersCount
    }
    var previewMessage:String{
        switch lastMessageType {
        case .admin:
            return "Newly Created Chat!"
        case .text:
            return lastMessage
        case .photo:
            return "Photo Message"
        case .video:
            return "Video Message"
        case .audio:
            return "Voice Message"
        }
    }
    
    static let placeholder = ChannelItem(id: "1", lastMessage: "Hello", creationDate: Date(), lastMessageTimeStamp: Date(), membersCount: 2, adminUids: [], membersUids: [], members: [], createdBy: "", lastMessageType: .text)
}

extension ChannelItem {
    init(_ dict: [String: Any]) {
        self.id = dict[.id] as? String ?? ""
        self.name = dict[.name] as? String? ?? nil
        self.lastMessage = dict[.lastMessage] as? String ?? ""
        let creationInterval = dict[.creationDate] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: creationInterval)
        let lastMessagetimeStampInterval = dict[.lastMessageTimeStamp] as? Double ?? 0
        self.lastMessageTimeStamp = Date(timeIntervalSince1970: lastMessagetimeStampInterval)
        self.membersCount = dict[.membersCount] as? Int ?? 0
        self.adminUids = dict[.adminUids] as? [String] ?? []
        self.thumbnailUrl = dict[.thumbnailUrl] as? String ?? nil
        self.membersUids = dict[.membersUids] as? [String] ?? []
        self.members = dict[.members] as? [UserItem] ?? []
        self.createdBy = dict[.createdBy] as? String ?? ""
        let msfTypeValue = dict[.lastMessageType] as? String ?? "text"
        self.lastMessageType = MessageType(msfTypeValue) ?? .text
    }
}

extension String {
    static let id = "id"
    static let name = "name"
    static let lastMessage = "lastMessage"
    static let creationDate = "creationDate"
    static let lastMessageTimeStamp = "lastMessageTimeStamp"
    static let membersCount = "membersCount"
    static let adminUids = "adminUids"
    static let membersUids = "membersUids"
    static let thumbnailUrl = "thumbnailUrl"
    static let members = "members"
    static let createdBy = "createdBy"
    static let lastMessageType = "lastMessageType"
}
