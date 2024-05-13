//
//  MessageItems+Types.swift
//  Whatsapp_Clone
//
//  Created by Kareddy Hemanth Reddy on 11/05/24.
//

import Foundation

enum AdminMessageType:String{
    case channelCreation
    case memberAdded
    case memberLeft
    case channelNameChanged
}


enum MessageType{
    case text , photo, video,audio
    
    var title:String{
        switch self {
        case .text:
            return "text"
        case .photo:
            return "photo"
        case .video:
            return "video"
        case .audio:
            return "audio"
        }
    }
}



enum MessageDirection{
    case sent,received
    
    static var random:MessageDirection{
        return [MessageDirection.sent,.received].randomElement() ?? .sent
    }
}

