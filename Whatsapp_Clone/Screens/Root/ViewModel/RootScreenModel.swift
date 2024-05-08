//
//  RootModel.swift
//  Whatsapp_Clone
//
//  Created by Kareddy Hemanth Reddy on 02/05/24.
//

import Foundation
import Combine

@Observable
final class RootScreenModel{
    private(set) var authState = AuthState.pending
    private var cancellable:AnyCancellable?
    
    init(){
       cancellable =  AuthManager.shared.authState.receive(on: DispatchQueue.main)
            .sink {[weak self] latestAuthState in
                self?.authState = latestAuthState
                print(self?.authState)
            }
    }
}
