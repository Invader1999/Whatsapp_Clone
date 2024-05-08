//
//  RootSrceen.swift
//  Whatsapp_Clone
//
//  Created by Kareddy Hemanth Reddy on 02/05/24.
//

import SwiftUI

struct RootSrceen: View {
    @State private var viewModel = RootScreenModel()
    
    var body: some View {
        switch viewModel.authState{
        case .pending:
            ProgressView().controlSize(.large)
            
            
        case .loggedIn(let loggedInUser):
            MainTabView(currentUser: loggedInUser)
       
        case .loggedOut:
            LoginScreen()
        }
    }
}

#Preview {
    RootSrceen()
}
