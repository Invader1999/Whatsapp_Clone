//
//  BubbleView.swift
//  Whatsapp_Clone
//
//  Created by Kareddy Hemanth Reddy on 06/07/24.
//

import SwiftUI

struct BubbleView: View {
    let message:MessageItem
    let channel:ChannelItem
    let isNewDay:Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if isNewDay{
                newDayTimeStampTextView()
                    .padding()
            }
            composeDynamicBubbleView()
        }
        .frame(maxWidth: .infinity)
    }
    
    @ViewBuilder
    private func composeDynamicBubbleView()-> some View{
        switch message.type{
        case .text:
            BubbuleTextView(item: message)
        case .video,.photo:
            BubbleImageView(item:message)
        case .audio:
            BubbleVoiceView(item: message)
        case .admin(let adminType):
            switch adminType {
            case .channelCreation:
                
                newDayTimeStampTextView()
                
                ChannelCreationTextView()
                    .padding()
                
                if channel.isGroupChat{
                    AdminMessageTextView(channel: channel)
                        
                }
            default:
                Text("UNKOWN")
            }
        }
    }
    
    private func newDayTimeStampTextView()-> some View{
        Text(message.timeStamp.relativeDateString)
            .font(.caption)
            .bold()
            .padding(.vertical,3)
            .padding(.horizontal)
            .background(Color.whatsAppGray)
            .clipShape(Capsule())
            .frame(maxWidth: .infinity)
    }
}

#Preview {
    BubbleView(message: .sentPlaceholder, channel: .placeholder, isNewDay: false)
}
