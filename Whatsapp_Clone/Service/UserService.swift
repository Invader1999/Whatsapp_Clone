//
//  UserService.swift
//  Whatsapp_Clone
//
//  Created by Kareddy Hemanth Reddy on 11/05/24.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseDatabaseSwift


struct UserService{
    
    static func getUsers(with uids:[String],completion: @escaping (UserNode) -> Void){
        var users:[UserItem] = []
        for uid in uids{
            let query = FirebaseConstants.UserRef.child(uid)
            query.observeSingleEvent(of: .value) { snapshot in
                guard let user = try? snapshot.data(as: UserItem.self) else {return}
                users.append(user)
                if users.count == uids.count{
                    completion(UserNode(users: users))
                }
            } withCancel: { error in
                completion(.emptyNode)
            }

            
        }
    }
    
    static func paginateUsers(lastCursor:String?, pageSize:UInt)async throws -> UserNode{
        let mainSnapshot:DataSnapshot
        if lastCursor == nil{
            mainSnapshot = try await FirebaseConstants.UserRef.queryLimited(toLast: pageSize).getData()
        }else{
            mainSnapshot =  try await FirebaseConstants.UserRef
                .queryOrderedByKey()
                .queryEnding(atValue: lastCursor)
                .queryLimited(toLast: pageSize + 1)
                .getData()
        }
        
        guard let first = mainSnapshot.children.allObjects.first as? DataSnapshot,
              let allObjects = mainSnapshot.children.allObjects as? [DataSnapshot] else {return .emptyNode}
        
        let users:[UserItem] = allObjects.compactMap { userSnapshot in
            let userDict =  userSnapshot.value as? [String:Any] ?? [:]
            return UserItem(dictionary: userDict)
        }
        
        if users.count == mainSnapshot.childrenCount{
            let filteredUsers = lastCursor == nil ? users : users.filter{$0.uid != lastCursor}
            let userNode = UserNode(users: filteredUsers,currentCursor: first.key)
            return userNode
        }
        return .emptyNode
    }
    
    //    static func paginateUsers(lastCursor:String?, pageSize:UInt)async throws -> UserNode{
    //        if lastCursor == nil{
    //
    //            let mainSnapshot = try await FirebasConstants.UserRef.queryLimited(toLast: pageSize).getData()
    //            guard let first = mainSnapshot.children.allObjects.first as? DataSnapshot,
    //                  let allObjects = mainSnapshot.children.allObjects as? [DataSnapshot] else {return .emptyNode}
    //
    //            let users:[UserItem] = allObjects.compactMap { userSnapshot in
    //                let userDict =  userSnapshot.value as? [String:Any] ?? [:]
    //                return UserItem(dictionary: userDict)
    //            }
    //
    //            if users.count == mainSnapshot.childrenCount{
    //                let userNode = UserNode(users: users,currentCursor: first.key)
    //                return userNode
    //            }
    //
    //            return .emptyNode
    //        }else{
    //            let mainSnapshot = try await FirebasConstants.UserRef
    //                .queryOrderedByKey()
    //                .queryEnding(atValue: lastCursor)
    //                .queryLimited(toLast: pageSize + 1)
    //                .getData()
    //
    //            guard let first = mainSnapshot.children.allObjects.first as? DataSnapshot,
    //                  let allObjects = mainSnapshot.children.allObjects as? [DataSnapshot] else {return .emptyNode}
    //
    //            let users:[UserItem] = allObjects.compactMap { userSnapshot in
    //                let userDict =  userSnapshot.value as? [String:Any] ?? [:]
    //                return UserItem(dictionary: userDict)
    //            }
    //
    //            if users.count == mainSnapshot.childrenCount{
    //                let filteredUsers = users.filter{$0.uid != lastCursor}
    //                let userNode = UserNode(users: filteredUsers,currentCursor: first.key)
    //                return userNode
    //            }
    //            return .emptyNode
    //        }
    //    }
}

struct UserNode{
    var users:[UserItem]
    var currentCursor:String?
    static let emptyNode = UserNode(users: [],currentCursor: nil)
}
