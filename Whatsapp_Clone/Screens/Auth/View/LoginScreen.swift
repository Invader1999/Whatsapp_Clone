//
//  LoginScreen.swift
//  Whatsapp_Clone
//
//  Created by Kareddy Hemanth Reddy on 27/04/24.
//

import SwiftUI

struct LoginScreen: View {
    
    
    @State private var authScreenModel = AuthScreenModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                AuthHeaderView()
                
                AuthTextField(text: $authScreenModel.email, type: .email)
                
                AuthTextField(text: $authScreenModel.password, type: .password)
                
                forgotPasswordButton()
                
                AuthButton(title: "Log in now") {
                    Task{
                        await authScreenModel.handleLogin()
                    }
                }
                .disabled(authScreenModel.disableLoginButton)
                
                Spacer()
                
                signUpButton()
                    .padding(.bottom,30)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.teal.gradient)
            .ignoresSafeArea()
            .alert(isPresented: $authScreenModel.errorState.showError, content: {
                Alert(
                    title: Text(authScreenModel.errorState.errorMessage),
                    dismissButton: .default(Text("OK"))
                )
            })
        }
    }
    
    private func forgotPasswordButton()->some View {
        Button {} label: {
            Text("Forgot Password ?")
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.trailing, 32)
                .bold()
                .padding(.vertical)
        }
    }
    
    private func signUpButton()->some View {
        NavigationLink {
            SignUpScreen(authScreenModel: authScreenModel)
                
        } label: {
            HStack {
                Image(systemName: "sparkles")
                
                Text("Don't have an account ? ")
                    
                    +
                    
                Text("Create One").bold()
            }
            .foregroundStyle(.white)
        }
    }
}

#Preview {
    NavigationStack{
        LoginScreen()
    }
}
