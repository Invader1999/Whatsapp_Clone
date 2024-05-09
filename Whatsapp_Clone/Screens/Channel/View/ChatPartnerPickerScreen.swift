//
//  ChatPartnerPickerScreen.swift
//  Whatsapp_Clone
//
//  Created by Kareddy Hemanth Reddy on 03/05/24.
//

import SwiftUI

struct ChatPartnerPickerScreen: View {
    @State private var searchText = ""
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel =  ChatPartnerPickerViewModel()
    var body: some View {
        NavigationStack(path:$viewModel.navStaack){
            List {
                ForEach(ChatPartnerPickerOption.allCases){item in
                    HeaderItemView(item: item)
                        .onTapGesture {
                            viewModel.navStaack.append(.addGroupChatMembers)
                        }
                }
                
                Section {
                    ForEach(0..<13) { _ in
                        ChatPartnerRowView(user: .placeholder)
                    }
                }header: {
                    Text("Contacts on Whatsapp")
                        .textCase(.none)
                        .bold()
                }
            }
            .searchable(text: $searchText,placement: .navigationBarDrawer(displayMode: .always),prompt: "Search name or number")
            .navigationTitle("New Chat")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: ChannelCreationRoute.self) { route in
                destinationView(for: route)
            }
            .toolbar{
                trailingNavItem()
            }
        }
               
    }
}
extension ChatPartnerPickerScreen{
    @ViewBuilder
    func destinationView(for route:ChannelCreationRoute)->some View{
        switch route {
        case .addGroupChatMembers:
           AddGroupChatPartnersScreen(viewModel: viewModel)
        case .setupGroupChat:
            Text("Setup Chat")
        }
    }
}

extension ChatPartnerPickerScreen{
    
    @ToolbarContentBuilder
    private func trailingNavItem()->some ToolbarContent{
        ToolbarItem(placement: .topBarTrailing) {
            cancelButton()
        }
    }
    
    private func cancelButton()-> some View{
        Button{
            dismiss()
        }label: {
            Image(systemName: "xmark")
                .font(.footnote)
                .bold()
                .foregroundStyle(.gray)
                .padding(8)
                .background(Color(.systemGray5))
                .clipShape(Circle())
        }
    }
}

extension ChatPartnerPickerScreen{
    private struct HeaderItemView:View {
        
        let item:ChatPartnerPickerOption
        var body: some View {
            Button{
                
            }label:{
                buttonBody()
            }
        }
        
        private func buttonBody()->some View{
            HStack{
                Image(systemName: item.imageName)
                    .font(.footnote)
                    .frame(width: 40,height: 40)
                    .background(Color(.systemGray6))
                    .clipShape(Circle())
                
                Text(item.title)
            }
        }
    }
}

enum ChatPartnerPickerOption: String, CaseIterable, Identifiable {
    case newGroup = "New Group"
    case newContact = "New Contact"
    case newCommunity = "New Community"

    var id: String {
        return rawValue
    }

    var title: String {
        return rawValue
    }
    
    var imageName:String{
        switch self {
        case .newGroup:
            return "person.2.fill"
        case .newContact:
            return "person.fill.badge.plus"
        case .newCommunity:
            return "person.3.fill"
        }
    }
}



#Preview {
    ChatPartnerPickerScreen()
}
