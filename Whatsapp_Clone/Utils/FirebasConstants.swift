//
//  FirebasConstants.swift
//  Whatsapp_Clone
//
//  Created by Kareddy Hemanth Reddy on 03/05/24.
//

import Foundation
import Firebase
import FirebaseStorage

enum FirebasConstants{
    private static let DatabaseRef = Database.database().reference()
    static let UserRef = DatabaseRef.child("users")
}
