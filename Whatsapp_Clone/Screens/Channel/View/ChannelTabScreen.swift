//
//  ChatsTabScreen.swift
//  Whatsapp_Clone
//
//  Created by Kareddy Hemanth Reddy on 24/04/24.
//

import SwiftUI

struct ChannelTabScreen: View {
    @State var searchText = ""
    @StateObject private var viewModel:ChannelTabViewModel
    
    init(_ currentUser:UserItem) {
        self._viewModel = StateObject(wrappedValue: ChannelTabViewModel(currentUser))
    }
    var body: some View {
        NavigationStack(path:$viewModel.navigationRoutes){
            List{
                archivedButton()
                
                ForEach(viewModel.channels) {channel in
                    Button{
                        viewModel.navigationRoutes.append(.chatRoom(channel))
                    }label: {
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
            .navigationDestination(for: ChannelTabRoutes.self){ route in
                destinationView(for: route)
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
    
    @ViewBuilder
    private func destinationView(for route:ChannelTabRoutes)-> some View{
        switch route{
        case .chatRoom(let channel):
            ChatRoomScreen(channel: channel)
        }
    }
    
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
    ChannelTabScreen(.placeholder)
}
