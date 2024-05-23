//
//  ChatRoomScreen.swift
//  Whatsapp_Clone
//
//  Created by Kareddy Hemanth Reddy on 24/04/24.
//

import SwiftUI

struct ChatRoomScreen: View {
    let channel:ChannelItem
    @StateObject private var viewModel:ChatRoomViewModel
    
    init(channel: ChannelItem) {
        self.channel = channel
        _viewModel = StateObject(wrappedValue: ChatRoomViewModel(channel))
       
    }
    
    var body: some View {
        MessageListView(viewModel)
        .toolbar(.hidden, for: .tabBar)
        .toolbar{
            leadingNavItems()
            trailingNavItems()
        }
        .navigationBarTitleDisplayMode(.inline)
        .safeAreaInset(edge: .bottom) {
            TextInputArea(textMessage: $viewModel.textMessage){
                viewModel.sendMessage()
            }
        }
    }
}

//MARK: - Tolbar Items
extension ChatRoomScreen{
    private var channelTitle:String{
        let maxChar = 20
        let trailingChars = channel.title.count > maxChar ? "..." : ""
        let title = String(channel.title.prefix(maxChar) + trailingChars )
        return title
    }
    
    @ToolbarContentBuilder
    private func leadingNavItems()->some ToolbarContent{
        ToolbarItem(placement: .topBarLeading) {
            HStack{
                CircularProfileImageView(channel, size: .mini)
                    //.frame(width: 35,height: 30)
                
                Text(channelTitle)
                    .bold()
            }
            .onAppear{
                print("\(channel.title) Name")
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
        ChatRoomScreen(channel: .placeholder)
    }
}
