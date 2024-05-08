//
//  AuthButton.swift
//  Whatsapp_Clone
//
//  Created by Kareddy Hemanth Reddy on 27/04/24.
//

import SwiftUI

struct AuthButton: View {
    let title:String
    let onTap:()->Void
    @Environment(\.isEnabled) private var isEnabled
    
    private var backgroundColor:Color{
        return isEnabled ? .white : .white.opacity(0.3)
    }
    
    
    private var textColor:Color{
        return isEnabled ? .green : .white
    }
    
    var body: some View {
        Button{
            onTap()
        }label: {
            HStack{
                Text(title)
                
                Image(systemName: "arrow.right")
            }
            .font(.headline)
            .foregroundStyle(textColor)
            .padding()
            .frame(maxWidth: .infinity)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 10,style: .continuous))
            .shadow(color: .green.opacity(0.2), radius: 10)
            .padding(.horizontal,32)
        }
    }
}

#Preview {
    AuthButton(title: "Login"){
        
    }
}
