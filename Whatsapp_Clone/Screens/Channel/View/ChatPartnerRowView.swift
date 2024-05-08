//
//  ChatPartnerRowView.swift
//  Whatsapp_Clone
//
//  Created by Kareddy Hemanth Reddy on 08/05/24.
//

import SwiftUI

struct ChatPartnerRowView: View {
    
    let user:UserItem
    var body: some View {
        HStack{
            Circle()
                .frame(width: 40,height: 40)
            
            VStack(alignment:.leading){
                Text(user.username)
                    .bold()
                    .foregroundStyle(.whatsAppBlack)
                
                Text(user.bioUnwrapped)
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
        }
    }
}

#Preview {
    ChatPartnerRowView(user: .placeholder)
}
