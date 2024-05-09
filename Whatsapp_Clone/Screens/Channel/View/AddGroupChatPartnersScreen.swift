//
//  AddGroupChatPartnersScreen.swift
//  Whatsapp_Clone
//
//  Created by Kareddy Hemanth Reddy on 09/05/24.
//

import SwiftUI

struct AddGroupChatPartnersScreen: View {
    @State private var searchText = ""
    @State var viewModel:ChatPartnerPickerViewModel
    var body: some View {
        List {
            if viewModel.showSelectedUsers{
                Text("User selected")
            }
            Section{
                ForEach([UserItem.placeholder]) { item in
                    Button{
                        viewModel.handleItemSelection(item)
                    }label: {
                        chatPartnerRowView(.placeholder)
                    }
                }
            }
        }
        .animation(.easeInOut,value: viewModel.showSelectedUsers)
        .searchable(text: $searchText,placement: .navigationBarDrawer(displayMode: .always),prompt: "Search name or number")
    }
    
    private func chatPartnerRowView(_ user:UserItem)->some View{
        ChatPartnerRowView(user: .placeholder) {
            Spacer()
            let isSelected = viewModel.isUserSelected(user)
            
            Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                .foregroundStyle(isSelected ? Color.blue : Color(.systemGray4))
                .imageScale(.large)
        }
    }
}

#Preview {
    
    NavigationStack{
        AddGroupChatPartnersScreen(viewModel: ChatPartnerPickerViewModel())
    }
}
