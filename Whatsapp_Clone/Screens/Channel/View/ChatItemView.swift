//
//  ChannelItemView.swift
//  Whatsapp_Clone
//
//  Created by Kareddy Hemanth Reddy on 24/04/24.
//

import SwiftUI

struct ChatItemView: View {
    let channel:ChannelItem
    var body: some View {
        HStack(alignment: .top,spacing: 10){
           Circle()
                .frame(width: 60,height: 60)
            
            VStack(alignment:.leading,spacing: 3){
                titleTextView()
                lastMessagePreview()
            }
        }
    }
    
    private func titleTextView()->some View{
        HStack{
            Text(channel.title)
                .lineLimit(1)
                .bold()
            
            Spacer()
            
            Text("\(channel.lastMessageTimeStamp)")
                .foregroundStyle(.gray)
                .font(.system(size: 15))
        }
    }
    
    private func lastMessagePreview() ->some View{
        Text(channel.lastMessage)
            .font(.system(size: 16))
            .lineLimit(2)
            .foregroundStyle(.gray)
    }
}

#Preview {
    ChatItemView(channel: .placeholder)
}
