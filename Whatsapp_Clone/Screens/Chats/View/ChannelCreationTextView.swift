//
//  ChannelCreationTextView.swift
//  Whatsapp_Clone
//
//  Created by Kareddy Hemanth Reddy on 18/05/24.
//

import SwiftUI

struct ChannelCreationTextView: View {
    
    @Environment(\.colorScheme) private var colorScheme
    
    private var backgroundColor:Color{
        return colorScheme == .dark ? Color.black : Color.yellow
    }
    var body: some View {
        ZStack(alignment:.top){
            (
                Text(Image(systemName:"lock.fill"))
                +
                Text(" Messages and calls are end-to-end encrypted, No one outside this chat, not even Whatsapp, can read or listen to them.")
                +
                Text(" Learn more.")
                    .bold()
            )
            .font(.footnote)
            .padding(10)
            .frame(maxWidth: .infinity)
            .background(backgroundColor.opacity(0.6))
            .clipShape(RoundedRectangle(cornerRadius: 8,style: .continuous))
            .padding(.horizontal, 30)
        }
    }
}

#Preview {
    ChannelCreationTextView()
}
