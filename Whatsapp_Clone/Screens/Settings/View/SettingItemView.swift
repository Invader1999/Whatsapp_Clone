//
//  SettingItemView.swift
//  Whatsapp_Clone
//
//  Created by Kareddy Hemanth Reddy on 24/04/24.
//

import SwiftUI

struct SettingItemView: View {
    let item: SettingsItem
    var body: some View {
        HStack {
            iconImageView()
                .frame(width: 30, height: 30)
                .foregroundStyle(.white)
                .background(item.backgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
            
            Text(item.title)
                .font(.system(size: 18))

            Spacer()
        }
    }

    @ViewBuilder
    private func iconImageView() -> some View {
        switch item.imageType {
        case .systemImage:
            Image(systemName: item.imageName)
                .bold()
                .font(.callout)
            
        case .assetImage:
            Image(item.imageName)
                .renderingMode(.template)
                .padding(3)
        }

    }
}

#Preview {
    SettingItemView(item: .chats)
}
