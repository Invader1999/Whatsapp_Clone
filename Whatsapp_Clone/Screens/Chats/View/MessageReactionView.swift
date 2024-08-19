//
//  MessageReactionView.swift
//  Whatsapp_Clone
//
//  Created by Kareddy Hemanth Reddy on 19/08/24.
//

import SwiftUI

struct MessageReactionView: View {
    let message:MessageItem
    private var emojis:[String]{
        message.reactions.map{$0.key}
    }
    //let emojis = ["👍","❤️","😂","😱","☹️","🙏"]
    
    private var emojisCount:Int{
       let stats = message.reactions.map{$0.value}
        
        return stats.reduce(0, +)
    }
    
    var body: some View {
       
        if message.hasReactions{
            HStack(spacing: 20) {
                ForEach(emojis,id: \.self){emoji in
                    Text(emoji)
                        .fontWeight(.semibold)
                }
                
                if emojisCount > 2{
                    Text(emojisCount.description)
                        .fontWeight(.semibold)
                }
            }
            .font(.footnote)
            .padding(4)
            .padding(.horizontal,2)
            .background(Capsule().fill(.thinMaterial))
            .overlay {
                Capsule()
                    .stroke(message.backgroundColor,lineWidth: 1.0)
            }
            .shadow(color: message.backgroundColor.opacity(0.3), radius: 5,x:0,y:5)
        }
    }
}

#Preview {
    MessageReactionView(message: .sentPlaceholder)
}
