//
//  SettingTabViewModel.swift
//  Whatsapp_Clone
//
//  Created by Kareddy Hemanth Reddy on 23/07/24.
//

import Foundation
import SwiftUI
import PhotosUI
import Combine
import Firebase
import AlertKit

@MainActor
final class SettingTabViewModel:ObservableObject{
    
    @Published var selectedPhotoItem:PhotosPickerItem?
    @Published var profilePhoto:MediaAttachment?
    @Published var showProgressHUD:Bool = false
    @Published var showSuccessHUD:Bool = false
    @Published var showUserInfoEditor:Bool = false
    @Published var name = ""
    @Published var bio = ""
    
    private var currentUser:UserItem
    
    
    private(set) var progresHUDView = AlertAppleMusic17View(title: "Uploading Profile Photo", subtitle: nil, icon: .spinnerSmall)
    
    private(set) var successHUDView = AlertAppleMusic17View(title: "Profile Info Updated", subtitle: nil, icon: .done)
    
    
    
    private var subscription: AnyCancellable?
    
    var disableSaveButton:Bool{
        return profilePhoto == nil || showProgressHUD 
    }
    
    init(_ currentUser:UserItem){
        self.currentUser = currentUser
        self.name = currentUser.username
        self.bio = currentUser.bio ?? ""
        onPhotoPickerSeclection()
    }
    
    private func onPhotoPickerSeclection(){
        subscription = $selectedPhotoItem
            .receive(on: DispatchQueue.main)
            .sink{[weak self] photoItem in
                guard let photoItem = photoItem else{return}
                self?.parsePhotoPickerItem(photoItem)
            }
    }
    
    
    private func parsePhotoPickerItem(_ photoItem:PhotosPickerItem){
        Task{
            guard let data = try? await photoItem.loadTransferable(type: Data.self),
            let uiImage = UIImage(data: data) else{return}
            self.profilePhoto = MediaAttachment(id: UUID().uuidString, type: .photo(uiImage))
        }
    }
    
    func uploadProfilePhoto(){
        guard let profilePhoto = profilePhoto?.thumbnail else {return}
        showProgressHUD = true
        FirebaseHelper.uploadImage(profilePhoto, for: .profilePhoto) {[weak self] result in
            switch result{
            case .success(let imageUrl):
                self?.onUploadSuccess(imageUrl)
            case .failure(let error):
                print("Failed To Upload profile image to firebaese storage :\(error.localizedDescription)")
            }
        } progressHandler: { progress in
            print("Uploading Image Progress \(progress)")
        }

    }
    
    private func onUploadSuccess(_ imageUrl:URL){
        guard let curretnUid = Auth.auth().currentUser?.uid else {return}
        FirebaseConstants.UserRef.child(curretnUid).child(.profileImageUrl).setValue(imageUrl.absoluteString)
        showProgressHUD = false
        progresHUDView.dismiss()
        currentUser.profileImageUrl = imageUrl.absoluteString
        AuthManager.shared.authState.send(.loggedIn(currentUser))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){ [self] in
            self.showSuccessHUD = true
            self.profilePhoto = nil
            self.selectedPhotoItem = nil
        }
       
        print("onUploadSuccess: \(imageUrl.absoluteString)")
    }
    
    func updateUsernameBio(){
        guard let curretnUid = Auth.auth().currentUser?.uid else {return}
        var dict: [String:Any] = [.bio:bio]
        currentUser.bio = bio
        
        if !name.isEmptyOrWhiteSpace{
            dict[.username] = name
            currentUser.username = name
        }
        
        FirebaseConstants.UserRef.child(curretnUid).updateChildValues(dict)
        showSuccessHUD = true
        AuthManager.shared.authState.send(.loggedIn(currentUser))
        
    }
}
