//
//  ReactionPickerView.swift
//  Whatsapp_Clone
//
//  Created by Kareddy Hemanth Reddy on 13/08/24.
//

import SwiftUI


struct EmojiReaction{
    let reaction:Reaction
    var isAnimating:Bool = false
    var opacity:CGFloat = 1
}

struct ReactionPickerView: View {
    let message:MessageItem
    let onTapHandler:((_ selectedEmoji:Reaction) -> Void)
    @State private var animateBackgroundView = false
    @State private var emojiState:[EmojiReaction] = [
        EmojiReaction(reaction: .like),
        EmojiReaction(reaction: .heart),
        EmojiReaction(reaction: .laugh),
        EmojiReaction(reaction: .shocked),
        EmojiReaction(reaction: .sad),
        EmojiReaction(reaction: .pray),
        EmojiReaction(reaction: .more)
    
    ]
    var body: some View {
        HStack(spacing: 10) {
            ForEach(Array(emojiState.enumerated()),id: \.offset){index , item in
                reactionButton(item, at: index)
            }
        }
        .padding(.horizontal,15)
        .padding(.vertical,10)
        .background(backgroundView())
        .shadow(color: Color.gray.opacity(0.2), radius: 4,x: 0,y: 0)
        .onAppear {
            withAnimation(.easeIn(duration: 0.2)){
                animateBackgroundView = true
            }
        }
    }
    
    private var springAnimation:Animation{
        Animation.spring(
            response: 0.55,
            dampingFraction: 0.6,
            blendDuration: 0.05
        ).speed(4)
    }
    
    private func reactionButton(_ item:EmojiReaction,at index:Int)-> some View{
        Button {
            guard item.reaction != .more else {return}
            onTapHandler(item.reaction)
                
        }label: {
            buttonBody(item, at: index)
                .scaleEffect(emojiState[index].isAnimating ? 1 : 0.01)
                .opacity(item.opacity)
                .onAppear {
                    let dynamicIndex = getAnimationIndex(index)
                    DispatchQueue.main.asyncAfter(deadline:.now() + 0.2){
                        withAnimation(springAnimation.delay(Double(dynamicIndex) * 0.05)){
                            emojiState[dynamicIndex].isAnimating = true
                        }
                    }
                }
        }
    }
    
    
    private func getAnimationIndex(_ index:Int) -> Int{
        if message.direction == .sent{
            let reversedIndex = emojiState.count - 1 - index
            return reversedIndex
        }else{
            return index
        }
    }
    
    
    @ViewBuilder
    private func buttonBody(_ item:EmojiReaction,at index:Int)-> some View{
        if item.reaction == .more{
            Image(systemName: "plus")
                .bold()
                .padding(8)
                .background(Color(.systemGray5))
                .clipShape(Circle())
                .foregroundStyle(.gray)
        }else{
            Text(item.reaction.emoji)
                .font(.system(size: 30))
                .background(selectedEmojiIndicator(item.reaction))
            
        }
    }
    
    private func selectedEmojiIndicator(_ reaction:Reaction)-> some View{
        Color(.systemGray5)
            .frame(width: 45,height: 45)
            .clipShape(Circle())
    }
    
    
    private func backgroundView()->some View{
        Capsule()
            .fill(Color.contextMenuTint)
            .mask {
                Capsule()
                    .fill(Color.contextMenuTint)
                    .scaleEffect(animateBackgroundView ? 1 : 0 , anchor: message.menuAnchor)
                    .opacity(animateBackgroundView ? 1 : 0)
            }
    }
}

#Preview {
    ReactionPickerView(message: .receivePlaceholder){ _ in
        
    }
}
