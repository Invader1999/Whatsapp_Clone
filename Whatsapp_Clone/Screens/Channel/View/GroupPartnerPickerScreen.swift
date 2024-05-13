//
//  AddGroupChatPartnersScreen.swift
//  Whatsapp_Clone
//
//  Created by Kareddy Hemanth Reddy on 09/05/24.
//

import SwiftUI

struct GroupPartnerPickerScreen: View {
    @State private var searchText = ""
    @State var viewModel:ChatPartnerPickerViewModel
    var body: some View {
        List {
            if viewModel.showSelectedUsers{
                SelectedChatPartnerView(users: viewModel.selectedChatPartners){user in
                    viewModel.handleItemSelection(user)
                }
            }
            Section{
                ForEach(viewModel.users) { item in
                    Button{
                        viewModel.handleItemSelection(item)
                    }label: {
                        chatPartnerRowView(item)
                    }
                }
            }
            
            if viewModel.isPaginatable{
                loadMoreUsers()
            }
        }
        .animation(.easeInOut,value: viewModel.showSelectedUsers)
        .searchable(text: $searchText,placement: .navigationBarDrawer(displayMode: .always),prompt: "Search name or number")
        .toolbar{
            titleView()
            trailingNavItem()
        }
    }
    
    private func chatPartnerRowView(_ user:UserItem)->some View{
        ChatPartnerRowView(user: user) {
            Spacer()
            let isSelected = viewModel.isUserSelected(user)
            
            Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                .foregroundStyle(isSelected ? Color.blue : Color(.systemGray4))
                .imageScale(.large)
        }
    }
    
    private func loadMoreUsers()-> some View{
        ProgressView()
            .frame(maxWidth: .infinity)
            .listRowBackground(Color.clear)
            .task {
                await viewModel.fetchUsers()
            }
    }
    
}

extension GroupPartnerPickerScreen{
    @ToolbarContentBuilder
    private func titleView()-> some ToolbarContent{
        ToolbarItem(placement: .principal) {
            VStack{
                Text("Add Participants")
                    .bold()
                let count = viewModel.selectedChatPartners.count
                let maxCount = ChannelConstants.maximumGroupParticipants
                Text("\(count)/\(maxCount)")
                    .foregroundStyle(.gray)
                    .font(.footnote)
            }
        }
    }
    
    
    
    @ToolbarContentBuilder
    private func trailingNavItem()-> some ToolbarContent{
        ToolbarItem(placement: .topBarTrailing) {
            Button{
                viewModel.navStack.append(.setupGroupChat)
            }label: {
                Text("Next")
                    .bold()
            }
            .disabled(viewModel.disableNextItem)
        }
    }
}

#Preview {
    
    NavigationStack{
        GroupPartnerPickerScreen(viewModel: ChatPartnerPickerViewModel())
    }
}
