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
    
    static let placeholders: [UserItem] = [
        UserItem(uid: "1", username: "Hemanth", email: "hemanthreddy056@gmail.com", bio: "Hello ' I am Hemanth"),
        UserItem(uid: "2", username: "Alice", email: "alice@example.com", bio: "Hey there! I'm Alice."),
        UserItem(uid: "3", username: "Bob", email: "bob@example.com", bio: "Hi, I'm Bob. Nice to meet you!"),
        UserItem(uid: "4", username: "Charlie", email: "charlie@example.com", bio: "Greetings! Charlie here."),
        UserItem(uid: "5", username: "Diana", email: "diana@example.com", bio: "Hello, I'm Diana. Let's connect!"),
        UserItem(uid: "6", username: "Eleanor", email: "eleanor@example.com", bio: "Hi, I'm Eleanor. Nice to e-meet you!"),
        UserItem(uid: "7", username: "Fiona", email: "fiona@example.com", bio: "Hello, I'm Fiona. Let's chat!"),
        UserItem(uid: "8", username: "Greg", email: "greg@example.com", bio: "Hey, Greg here. How's it going?"),
        UserItem(uid: "9", username: "Hannah", email: "hannah@example.com", bio: "Hi, I'm Hannah. Nice to meet you!"),
        UserItem(uid: "10", username: "Ian", email: "ian@example.com", bio: "Hey, I'm Ian. Let's connect and create!"),
    ]

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
