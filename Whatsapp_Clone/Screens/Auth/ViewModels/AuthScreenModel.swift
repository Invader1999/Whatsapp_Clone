//
//  AuthScreenModel.swift
//  Whatsapp_Clone
//
//  Created by Kareddy Hemanth Reddy on 29/04/24.
//

import Foundation
import Observation


@Observable
final class AuthScreenModel{
    
    var isLoading = false
    var email = ""
    var password = ""
    var username = ""
    var errorState:(showError:Bool,errorMessage:String) = (false,"Uh Oh")
    
    var disableLoginButton:Bool{
        return email.isEmpty || password.isEmpty || isLoading
    }
    
    var disableSignUpButton:Bool{
        return email.isEmpty || password.isEmpty || username.isEmpty || isLoading
    }
    
    @MainActor
    func handleSignUp()async {
        isLoading = true
        do {
            try await AuthManager.shared.createAccount(for: username, with: email, and: password)
        } catch{
            errorState.errorMessage = "Failed to create an account \(error.localizedDescription)"
            print(errorState.errorMessage)
            errorState.showError = true
            isLoading = false
        }
    }
    
    
    func handleLogin()async{
        isLoading = true
        do {
            try await AuthManager.shared.login(with: email, and: password)
        } catch {
            errorState.errorMessage = "Failed to login  \(error.localizedDescription)"
            print(errorState.errorMessage)
            errorState.showError = true
            isLoading = false
        }
    }
}
