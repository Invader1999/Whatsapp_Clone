//
//  SignUpScreen.swift
//  Whatsapp_Clone
//
//  Created by Kareddy Hemanth Reddy on 29/04/24.
//

import SwiftUI

struct SignUpScreen: View {
    @State var authScreenModel: AuthScreenModel
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack{
            Spacer()
            
            AuthHeaderView()
            
            AuthTextField(text: $authScreenModel.email , type: .email)
            
            let userName = AuthTextField.InputType.custom("Username", "at")
            
            AuthTextField(text: $authScreenModel.username, type: userName)
            
            AuthTextField(text: $authScreenModel.password, type: .password)
            
            AuthButton(title: "Create an Account") {
                Task{
                   await authScreenModel.handleSignUp()
                }
            }
            
            .disabled(authScreenModel.disableSignUpButton)
            
            
            Spacer()
            
            backButton()
                .padding(.bottom,30)
        }
        .frame(maxWidth: .infinity,maxHeight: .infinity)
        .background(
            LinearGradient(colors: [.green,.green.opacity(0.8),.teal], startPoint: .top, endPoint: .bottom)
        )
        .ignoresSafeArea()
        .navigationBarBackButtonHidden()
    }
    
    private func backButton()->some View{
        Button{
            dismiss()
        }label: {
            HStack {
                Image(systemName: "sparkles")
                
                Text("Already created an account ? ")
                    
                    +
                    
                Text("Log in").bold()
            }
            .foregroundStyle(.white)
        }
    }
}

#Preview {
    SignUpScreen(authScreenModel: AuthScreenModel())
}
