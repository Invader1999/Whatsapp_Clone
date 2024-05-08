//
//  ChatRoomScreen.swift
//  Whatsapp_Clone
//
//  Created by Kareddy Hemanth Reddy on 24/04/24.
//

import SwiftUI

struct ChatRoomScreen: View {
    var body: some View {
        ScrollView{
            LazyVStack{
                ForEach(0..<12) { _ in
                    Text("Placeholder")
                        .font(.largeTitle)
                        .bold()
                        .frame(maxWidth: .infinity)
                        .frame(height: 200)
                        .background(.gray.opacity(0.1))
                }
            }

        }
        .toolbar(.hidden, for: .tabBar)
        .toolbar{
            leadingNavItems()
            trailingNavItems()
        }
        .safeAreaInset(edge: .bottom) {
            TextInputArea()
        }
    }
}

//MARK: - Tolbar Items
extension ChatRoomScreen{
    @ToolbarContentBuilder
    private func leadingNavItems()->some ToolbarContent{
        ToolbarItem(placement: .topBarLeading) {
            HStack{
                Circle()
                    .frame(width: 35,height: 30)
                Text("Hemanth")
                    .bold()
            }
        }
    }
    
    
    @ToolbarContentBuilder
    private func trailingNavItems()->some ToolbarContent{
        ToolbarItemGroup(placement: .topBarTrailing) {
            Button{
                
            }label: {
                Image(systemName: "video")
            }
            
            Button{
                
            }label: {
                Image(systemName: "phone")
            }
        }
    }
}

#Preview {
    NavigationStack{
        ChatRoomScreen()
    }
}
