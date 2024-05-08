//
//  UserItem.swift
//  Whatsapp_Clone
//
//  Created by Kareddy Hemanth Reddy on 03/05/24.
//

import Foundation

struct UserItem:Identifiable,Hashable,Codable{
    let uid:String
    let username:String
    let email:String
    var bio:String? = nil
    var profileImageUrl:String? = nil
    
    
    var id:String{
        return uid
    }
    var bioUnwrapped:String{
        return bio ?? "Hey there! I am using Whatsapp"
    }
    static let placeholder = UserItem(uid: "1", username: "Hemanth", email: "hemanthreddy056@gmail.com")
}

extension UserItem{
    init(dictionary:[String:Any]){
        self.uid = dictionary[.uid] as? String ?? ""
        self.username = dictionary[.username] as? String ?? ""
        self.email = dictionary[.email] as? String ?? ""
        self.bio = dictionary[.bio] as? String? ?? nil
        self.profileImageUrl = dictionary[.profileImageUrl] as? String? ?? nil
    }
}

extension String{
    static let uid = "uid"
    static let username = "username"
    static let email = "email"
    static var bio = "bio"
    static var profileImageUrl = "profileImageUrl"
}
