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
    let text:String
    let type:MessageType
    let ownerUid:String
    var direction:MessageDirection{
        return ownerUid == Auth.auth().currentUser?.uid  ? .sent : .received
    }
    
    var alignment:Alignment{
        return direction == .received ? .leading : .trailing
    }
    
    var horizontalAlignment:HorizontalAlignment{
        return direction == .received ? .leading : .trailing
    }
    
    static let sentPlaceholder = MessageItem(id:UUID().uuidString, text: "Hello everyone", type: .text, ownerUid: "1")
    static let receivePlaceholder = MessageItem(id:UUID().uuidString, text: "How are you", type: .text, ownerUid: "2")
    
    var backgroundColor:Color{
        return direction == .sent ? .bubbleGreen : . bubbleWhite
    }
    
    static let stbMessages :[MessageItem] = [
        MessageItem(id:UUID().uuidString, text: "Hello Everyone", type: .text, ownerUid: "3"),
        MessageItem(id:UUID().uuidString, text: "How are you", type: .photo, ownerUid: "4"),
        MessageItem(id:UUID().uuidString, text: "How are you", type: .video, ownerUid: "5"),
        MessageItem(id:UUID().uuidString, text: "", type: .audio,ownerUid: "6")
    ]
}

extension MessageItem{
    init(id:String, dict:[String:Any]){
        self.id = id
        self.text = dict[.text] as? String ?? ""
        let type = dict[.type] as? String ?? "text"
        self.type = MessageType(type)
        self.ownerUid = dict[.ownerUid] as? String ?? ""
    }
}

extension String{
    static let `type` = "type"
    static let timeStamp = "timeStamp"
    static let ownerUid = "ownerUid"
    static let text = "text"
}
