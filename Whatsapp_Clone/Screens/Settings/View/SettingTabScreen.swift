//
//  SettingTabScreen.swift
//  Whatsapp_Clone
//
//  Created by Kareddy Hemanth Reddy on 24/04/24.
//

import SwiftUI

struct SettingTabScreen: View {
    @State var searchText = ""
    var body: some View {
        NavigationStack{
            List{
                SettingHeaderView()
                
                Section{
                    SettingItemView(item: .broadCastLists)
                    SettingItemView(item: .starredMessages)
                    SettingItemView(item: .linkedDevices)
                }
                Section{
                    SettingItemView(item: .account)
                    SettingItemView(item: .privacy)
                    SettingItemView(item: .chats)
                    SettingItemView(item: .notifications)
                    SettingItemView(item: .storage)
                }
                
                Section{
                    SettingItemView(item: .help)
                    SettingItemView(item: .tellFriend)
                }
                
            }
            .navigationTitle("Settings")
            .searchable(text: $searchText)
            .toolbar{
                leadingNavItem()
            }
        }
    }
}

extension SettingTabScreen{
    @ToolbarContentBuilder
    private func leadingNavItem() -> some ToolbarContent{
        ToolbarItem(placement: .topBarLeading) {
            Button("Sign Out"){
                Task{
                    try? await AuthManager.shared.logout()
                }
            }
            .foregroundStyle(.red)
        }
    }
}

private struct SettingHeaderView:View {
    var body: some View {
        Section{
            HStack{
                Circle()
                    .frame(width: 55,height: 55)
                
                userInfoTextView()
                
            }
            SettingItemView(item: .avatar)
        }
    }
    
    private func userInfoTextView()->some View{
        VStack(alignment:.leading,spacing: 0){
            HStack{
                Text("Hemanth Reddy")
                    .font(.title2)
                
                Spacer()
                
                Image(.qrcode)
                    .renderingMode(.template)
                    .padding(5)
                    .foregroundStyle(.blue)
                    .background(Color(.systemGray5))
                    .clipShape(Circle())
            }
            
            Text("Hey there I am using Whatsapp")
                .foregroundStyle(.gray)
                .font(.callout)
        }
        .lineLimit(1)
    }
}

#Preview {
    SettingTabScreen()
}
