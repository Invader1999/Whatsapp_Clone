//
//  MessageItem.swift
//  Whatsapp_Clone
//
//  Created by Kareddy Hemanth Reddy on 26/04/24.
//

import Foundation
import SwiftUI
import Firebase

struct MessageItem:Identifiable{
    let id:String
    let isGroupChat:Bool
    let text:String
    let type:MessageType
    let ownerUid:String
    var timeStamp:Date
    var sender:UserItem?
    let thumbnailUrl:String?
    let thumbnailHeight:CGFloat?
    let thumbnailWidth:CGFloat?
    
    var direction:MessageDirection{
        return ownerUid == Auth.auth().currentUser?.uid  ? .sent : .received
    }
    
    var alignment:Alignment{
        return direction == .received ? .leading : .trailing
    }
    
    var horizontalAlignment:HorizontalAlignment{
        return direction == .received ? .leading : .trailing
    }
    
    static let sentPlaceholder = MessageItem(id:UUID().uuidString, isGroupChat: true, text: "Hello everyone", type: .text, ownerUid: "1", timeStamp: Date(), thumbnailUrl: nil,thumbnailHeight: 0,thumbnailWidth: 0)
    static let receivePlaceholder = MessageItem(id:UUID().uuidString, isGroupChat: false, text: "How are you", type: .text, ownerUid: "2", timeStamp: Date(), thumbnailUrl: nil,thumbnailHeight: 0,thumbnailWidth: 0)
    
    var backgroundColor:Color{
        return direction == .sent ? .bubbleGreen : . bubbleWhite
    }
    
    var showGroupPartnerInfo:Bool{
        return isGroupChat && direction == .received
    }
    
    var leadingPadding:CGFloat{
        return direction == .received ? 0 : horizontalPadding
    }
    
    var trailingPadding:CGFloat{
        return direction == .received ? horizontalPadding : 0
    }
    
    private let horizontalPadding:CGFloat = 25
    
    var imageSize:CGSize{
        let photoWidth = thumbnailWidth ?? 0
        let photoHeight = thumbnailHeight ?? 0
        let imageHeight  = CGFloat(photoHeight / photoWidth * imageWidth)
        return CGSize(width: imageWidth, height: imageHeight)
    }
    
    var imageWidth:CGFloat{
        let photoWidth = (UIWindowScene.current?.screenWidth ?? 0) / 1.5
        return photoWidth
    }
    
    static let stbMessages :[MessageItem] = [
        MessageItem(id:UUID().uuidString, isGroupChat: false, text: "Hello Everyone", type: .text, ownerUid: "3", timeStamp: Date(), thumbnailUrl: nil,thumbnailHeight: 0,thumbnailWidth: 0),
        MessageItem(id:UUID().uuidString, isGroupChat: true, text: "How are you", type: .photo, ownerUid: "4", timeStamp: Date(), thumbnailUrl: nil,thumbnailHeight: 0,thumbnailWidth: 0),
        MessageItem(id:UUID().uuidString, isGroupChat: true, text: "How are you", type: .video, ownerUid: "5", timeStamp: Date(), thumbnailUrl: nil,thumbnailHeight: 0,thumbnailWidth: 0),
        MessageItem(id:UUID().uuidString, isGroupChat: false, text: "", type: .audio,ownerUid: "6", timeStamp: Date(), thumbnailUrl: nil,thumbnailHeight: 0,thumbnailWidth: 0)
    ]
}

extension MessageItem{
    init(id:String, isGroupChat:Bool,dict:[String:Any]){
        self.id = id
        self.isGroupChat = isGroupChat
        self.text = dict[.text] as? String ?? ""
        let type = dict[.type] as? String ?? "text"
        self.type = MessageType(type) ?? .text
        self.ownerUid = dict[.ownerUid] as? String ?? ""
        let timeInteval = dict[.timeStamp] as? TimeInterval ?? 0
        self.timeStamp = Date(timeIntervalSince1970: timeInteval)
        self.thumbnailUrl = dict[.thumbnailUrl] as? String ?? nil
        self.thumbnailWidth = dict[.thumbnailWidth] as? CGFloat ?? 0
        self.thumbnailHeight = dict[.thumbnailHeight] as? CGFloat ?? 0
    }
}

extension String{
    static let `type` = "type"
    static let timeStamp = "timeStamp"
    static let ownerUid = "ownerUid"
    static let text = "text"
    static let thumbnailWidth = "thumbnailWidth"
    static let thumbnailHeight = "thumbnailHeight"
}
