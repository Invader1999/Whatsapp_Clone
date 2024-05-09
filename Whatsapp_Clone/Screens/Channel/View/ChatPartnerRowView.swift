//
//  ChatPartnerRowView.swift
//  Whatsapp_Clone
//
//  Created by Kareddy Hemanth Reddy on 08/05/24.
//

import SwiftUI

struct ChatPartnerRowView<Content: View>: View {
    
    private let user:UserItem
    private let trailingItems: Content
    init(user: UserItem, @ViewBuilder trailingItems:()-> Content = {EmptyView()}) {
        self.user = user
        self.trailingItems = trailingItems()
    }
    
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
            
            trailingItems
        }
    }
}

#Preview {
    ChatPartnerRowView(user: .placeholder)
}
