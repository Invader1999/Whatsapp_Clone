//
//  MessageItem.swift
//  Whatsapp_Clone
//
//  Created by Kareddy Hemanth Reddy on 26/04/24.
//

import Foundation
import SwiftUI

struct MessageItem:Identifiable{
    
    let id = UUID().uuidString
    let text:String
    let type:MessageType
    let direction:MessageDirection
    
    var alignment:Alignment{
        return direction == .received ? .leading : .trailing
    }
    
    var horizontalAlignment:HorizontalAlignment{
        return direction == .received ? .leading : .trailing
    }
    
    static let sentPlaceholder = MessageItem(text: "Hello everyone", type: .text, direction: .sent)
    static let receivePlaceholder = MessageItem(text: "How are you", type: .text, direction: .received)
    
    var backgroundColor:Color{
        return direction == .sent ? .bubbleGreen : . bubbleWhite
    }
    
    static let stbMessages :[MessageItem] = [
        MessageItem(text: "Hello Everyone", type: .text, direction: .sent),
        MessageItem(text: "How are you", type: .photo, direction: .received),
        MessageItem(text: "How are you", type: .video, direction: .sent),
        MessageItem(text: "", type: .audio, direction: .received)
        
    ]
}

enum MessageType{
    case text , photo, video,audio
}



enum MessageDirection{
    case sent,received
    
    static var random:MessageDirection{
        return [MessageDirection.sent,.received].randomElement() ?? .sent
    }
}
