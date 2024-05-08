//
//  CustomModifiers.swift
//  Whatsapp_Clone
//
//  Created by Kareddy Hemanth Reddy on 26/04/24.
//

import Foundation
import SwiftUI

private struct BubbleTailModifier:ViewModifier{
    var direction:MessageDirection
    
    func body(content:Content) ->some View{
        content.overlay(alignment: direction == .received ? .bottomLeading :.bottomTrailing){
            BubbleTailView(direction: direction)
        }
    }
}

extension View{
    func applyTail(direction:MessageDirection)->some View{
        self.modifier(BubbleTailModifier(direction: direction))
    }
}
