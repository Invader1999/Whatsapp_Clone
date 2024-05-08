//
//  ChatsTabScreen.swift
//  Whatsapp_Clone
//
//  Created by Kareddy Hemanth Reddy on 24/04/24.
//

import SwiftUI

struct ChannelTabScreen: View {
    @State var searchText = ""
    @State private var showChatPartnerPickerView = false
    var body: some View {
        NavigationStack{
            List{
                archivedButton()
                ForEach(0..<12) { _ in
                    NavigationLink{
                        ChatRoomScreen()
                    }label:{
                        ChatItemView()
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
            .sheet(isPresented: $showChatPartnerPickerView){
                ChatPartnerPickerScreen()
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
            showChatPartnerPickerView = true
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
