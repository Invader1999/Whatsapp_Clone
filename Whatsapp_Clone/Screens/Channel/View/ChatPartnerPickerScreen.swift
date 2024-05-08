//
//  ChatPartnerPickerScreen.swift
//  Whatsapp_Clone
//
//  Created by Kareddy Hemanth Reddy on 03/05/24.
//

import SwiftUI

struct ChatPartnerPickerScreen: View {
    var body: some View {
        NavigationStack {
            List {
                ForEach(ChatPartnerPickerOption.allCases){item in
                    Label(item.title, systemImage: item.imageName)
                }
            }
            .navigationTitle("New Chat")
            .navigationBarTitleDisplayMode(.inline)
        }
               
    }
}

extension ChatPartnerPickerScreen{
    private struct HeaderItemView:View {
        var body: some View {
            VStack{
                
            }
        }
    }
}

enum ChatPartnerPickerOption: String, CaseIterable, Identifiable {
    case newGroup = "New Group"
    case newContact = "New Contact"
    case newCommunity = "New Community"

    var id: String {
        return rawValue
    }

    var title: String {
        return rawValue
    }
    
    var imageName:String{
        switch self {
        case .newGroup:
            return "person.2.fill"
        case .newContact:
            return "person.fill.badge.plus"
        case .newCommunity:
            return "person.3.fill"
        }
    }
}

#Preview {
    ChatPartnerPickerScreen()
}
