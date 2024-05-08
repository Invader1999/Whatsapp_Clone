//
//  AuthHeaderView.swift
//  Whatsapp_Clone
//
//  Created by Kareddy Hemanth Reddy on 27/04/24.
//

import SwiftUI

struct AuthHeaderView: View {
    var body: some View {
        HStack{
            Image(.whatsapp)
                .resizable()
                .frame(width: 40,height: 40)
            Text("Whatsapp")
                .font(.largeTitle)
                .foregroundStyle(.white)
                .fontWeight(.semibold)
        }
    }
}

#Preview {
    AuthHeaderView()
}
