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
        VStack(alignment:item.horizontalAlignment, spacing:3){
            Text(item.text)
                .padding(10)
                .background(item.backgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: 16,style: .continuous))
                .applyTail(direction: item.direction)
                
            timeStampTextView()
        }
        .shadow(color: Color(.systemGray3).opacity(0.1), radius: 5,x: 0,y: 20)
        .frame(maxWidth: .infinity,alignment: item.alignment)
        .padding(.leading,item.direction == .received ? 5 : 100)
        .padding(.trailing,item.direction == .received ? 100 : 5)
    }
    private func timeStampTextView()->some View{
        HStack{
            Text("3:50 PM")
                .font(.system(size: 13))
                
                .foregroundStyle(.gray)
                
            if item.direction == .sent{
                Image(.seen)
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 15,height: 15)
                    .foregroundStyle(Color(.systemBlue))
            }
        }
    }
}

#Preview {
    BubbuleTextView(item: .sentPlaceholder)
        
}
