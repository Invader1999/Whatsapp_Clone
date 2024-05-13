//
//  ChatsTabScreen.swift
//  Whatsapp_Clone
//
//  Created by Kareddy Hemanth Reddy on 24/04/24.
//

import SwiftUI

struct ChannelTabScreen: View {
    @State var searchText = ""
    @State private var viewModel = ChannelTabViewModel()
    var body: some View {
        NavigationStack{
            List{
                archivedButton()
                
                ForEach(viewModel.channels) {channel in
                    NavigationLink{
                        ChatRoomScreen(channel: channel)
                    }label:{
                        ChatItemView(channel: channel)
                    }
                }
                
                inboxFooterView()
                    .listRowSeparator(.hidden)
            }
            .navigationTitle("Chats")
            .searchable(text: $searchText)
            .listStyle(.plain)
            .toolbar{
                leadingNavItems()
                trailingNavItems()
            }
            .sheet(isPresented: $viewModel.showChatPartnerPickerView){
                ChatPartnerPickerScreen(onCreate:viewModel.onNewChannelCreation)
            }
            .navigationDestination(isPresented: $viewModel.navigateToChatRoom) {
                if let newChannel = viewModel.newChannel{
                    ChatRoomScreen(channel: newChannel)
                }
            }
        }
    }
}

extension ChannelTabScreen{
    @ToolbarContentBuilder
    private func leadingNavItems()->some ToolbarContent{
        ToolbarItem(placement: .topBarLeading) {
            Menu {
                Button {
                    
                } label: {
                    Label("Select Chats", systemImage: "checkmark.circle")
                }

            } label: {
                Image(systemName: "ellipsis.circle")
            }

        }
    }
    
    
    @ToolbarContentBuilder
    private func trailingNavItems()->some ToolbarContent{
        ToolbarItemGroup(placement: .topBarTrailing){
            aiButton()
            cameraButton()
            newChatButton()
        }
        
    }
    private func aiButton()->some View{
        Button{
            
        }label: {
            Image(.circle)
        }
    }
    
    private func newChatButton()->some View{
        Button{
            viewModel.showChatPartnerPickerView = true
        }label: {
            Image(.plus)
        }
    }
    
    
    private func cameraButton()->some View{
        Button{
            
        }label: {
            Image(systemName: "camera")
        }
    }
    
    private func archivedButton()->some View{
        Button{
            
        }label: {
            Label("Archived",systemImage:"archivebox.fill")
                .bold()
                .padding()
                .foregroundStyle(.gray)
        }
    }
    
    private func inboxFooterView()->some View{
        HStack{
            Image(systemName: "lock.fill")
            
            (
                Text("Your personal messages are ")
                +
                Text("end-to-end encypted")
                    .foregroundStyle(.blue)
            )
           
        }
        .foregroundStyle(.gray)
        .font(.caption)
        .padding(.horizontal)
    }
}

#Preview {
    ChannelTabScreen()
}
