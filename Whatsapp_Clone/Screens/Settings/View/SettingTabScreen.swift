//
//  SettingTabScreen.swift
//  Whatsapp_Clone
//
//  Created by Kareddy Hemanth Reddy on 24/04/24.
//

import SwiftUI
import PhotosUI

struct SettingTabScreen: View {
    @State var searchText = ""
    @StateObject private var viewModel:SettingTabViewModel
    private let currentUser:UserItem
    
    init(_ currentUser:UserItem){
        self.currentUser = currentUser
        self._viewModel = StateObject(wrappedValue: SettingTabViewModel(currentUser))
    }
    
    var body: some View {
        NavigationStack{
            List{
                SettingHeaderView(viewModel,currentUser)
                
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
                trailingNavItem()
            }
            .alert(isPresent: $viewModel.showProgressHUD, view: viewModel.progresHUDView)
            .alert(isPresent: $viewModel.showSuccessHUD, view: viewModel.successHUDView)
            .alert("Update Your Profile",isPresented: $viewModel.showUserInfoEditor){
                TextField("Username", text: $viewModel.name)
                TextField("Bio", text: $viewModel.bio)
                Button("Update"){
                    viewModel.updateUsernameBio()
                }
                Button("Cancel",role: .cancel){
                    
                }
            }message: {
                Text("Enter you new username or bio")
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
    
    
    @ToolbarContentBuilder
    private func trailingNavItem() -> some ToolbarContent{
        ToolbarItem(placement: .topBarTrailing) {
            Button("Save"){
                viewModel.uploadProfilePhoto()
            }
            .bold()
            .disabled(viewModel.disableSaveButton)
        }
    }
}

private struct SettingHeaderView:View {
    private let currentUser:UserItem
    
    @ObservedObject private var viewModel:SettingTabViewModel
    
    init(_ viewModel: SettingTabViewModel,_ currentUser:UserItem) {
        self.viewModel = viewModel
        self.currentUser = currentUser
    }
    
    var body: some View {
        Section{
            HStack{
                profileImaageView()
                
                userInfoTextView()
                    .onTapGesture {
                        viewModel.showUserInfoEditor = true
                    }
                    
                
            }
            
            PhotosPicker(selection: $viewModel.selectedPhotoItem,matching: .not(.videos)) {
                SettingItemView(item: .avatar)
            }
            
        }
    }
    
    @ViewBuilder
    private func profileImaageView()-> some View{
        if let profilePhoto = viewModel.profilePhoto{
            Image(uiImage: profilePhoto.thumbnail)
                .resizable()
                .frame(width: 55,height: 55)
                .clipShape(Circle())
        }else{
            CircularProfileImageView(currentUser.profileImageUrl,size: .custom(55))
        }
    }
    
    
    private func userInfoTextView()->some View{
        VStack(alignment:.leading,spacing: 0){
            HStack{
                Text(currentUser.username)
                    .font(.title2)
                
                Spacer()
                
                Image(.qrcode)
                    .renderingMode(.template)
                    .padding(5)
                    .foregroundStyle(.blue)
                    .background(Color(.systemGray5))
                    .clipShape(Circle())
            }
            
            Text(currentUser.bioUnwrapped)
                .foregroundStyle(.gray)
                .font(.callout)
        }
        .lineLimit(1)
    }
}

#Preview {
    SettingTabScreen(.placeholder)
}
