//
//  BubbleVoiceView.swift
//  Whatsapp_Clone
//
//  Created by Kareddy Hemanth Reddy on 26/04/24.
//

import SwiftUI

struct BubbleVoiceView: View {
    let item: MessageItem
    @State var sliderValue: Double = 0
    @State var sliderRange: ClosedRange<Double> = 0 ... 20
    var body: some View {
        HStack(alignment: .bottom, spacing: 5) {
            if item.showGroupPartnerInfo {
                CircularProfileImageView(item.sender?.profileImageUrl, size: .mini)
                    .offset(y: 5)
            }
            if item.direction == .sent {
                timeStampTextView()
            }
            
            HStack {
                playButton()
                Slider(value: $sliderValue, in: sliderRange)
                    .tint(.gray)
                
                Text("04:00")
                    .foregroundStyle(.gray)
            }
            .padding(10)
            .background(Color.gray.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .padding(5)
            .background(item.backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .applyTail(direction: item.direction)
            
            if item.direction == .received {
                timeStampTextView()
            }
        }
        .shadow(color: Color(.systemGray3).opacity(0.1), radius: 5, x: 0, y: 20)
        .frame(maxWidth: .infinity, alignment: item.alignment)
        .padding(.leading, item.leadingPadding)
        .padding(.trailing, item.trailingPadding)
    }
    
    private func playButton()->some View {
        Button {} label: {
            Image(systemName: "play.fill")
                .padding(10)
                .background(item.direction == .received ? .green : .white)
                .clipShape(Circle())
                .foregroundStyle(item.direction == .received ? .white : .black)
        }
    }
    
    private func timeStampTextView()->some View {
        Text("3:50 PM")
            .font(.footnote)
            .foregroundStyle(.gray)
    }
}

#Preview {
    BubbleVoiceView(item: .sentPlaceholder)
        .onAppear {
            let thumbImage = UIImage(systemName: "circle.fill")
            UISlider.appearance().setThumbImage(thumbImage, for: .normal)
        }
}
