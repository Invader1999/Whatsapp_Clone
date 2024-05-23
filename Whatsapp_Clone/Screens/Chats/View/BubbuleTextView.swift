//
//  BubbuleTextView.swift
//  Whatsapp_Clone
//
//  Created by Kareddy Hemanth Reddy on 26/04/24.
//

import SwiftUI

struct BubbuleTextView: View {
    var item:MessageItem
    var body: some View {
        HStack(alignment:.bottom, spacing:5){
            if item.showGroupPartnerInfo{
                CircularProfileImageView(item.sender?.profileImageUrl,size: .mini)
            }
            
            if item.direction == .sent{
                timeStampTextView()
            }
            Text(item.text)
                .padding(10)
                .background(item.backgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: 16,style: .continuous))
                .applyTail(direction: item.direction)
                
            if item.direction == .received{
                timeStampTextView()
            }
        }
        .shadow(color: Color(.systemGray3).opacity(0.1), radius: 5,x: 0,y: 20)
        .frame(maxWidth: .infinity,alignment: item.alignment)
        .padding(.leading,item.leadingPadding)
        .padding(.trailing,item.trailingPadding)
    }
    
    private func timeStampTextView()->some View{
            Text(item.timeStamp.formatToTime)
                .font(.footnote)
                .foregroundStyle(.gray)
    }
}

#Preview {
    BubbuleTextView(item: .sentPlaceholder)
        
}
