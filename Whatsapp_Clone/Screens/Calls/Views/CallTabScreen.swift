//
//  CallTabScreen.swift
//  Whatsapp_Clone
//
//  Created by Kareddy Hemanth Reddy on 23/04/24.
//

import SwiftUI

struct CallTabScreen: View {
    @State private var searchText = ""
    @State private var callHistory = CallHistory.all
    var body: some View {
        NavigationStack{
            List{
                Section{
                    CreateCallLinkSection()
                }
                
                Section{
                    ForEach(0..<12) { item in
                        RecentCallItemView()
                    }
                    
                }header: {
                    Text("Recent")
                        .textCase(nil)
                        .font(.headline)
                        .bold()
                        .foregroundStyle(.whatsAppBlack)
                }
            }
            .navigationTitle("Calls")
            .searchable(text: $searchText)
            .toolbar{
                leadingNavItem()
                trailingNavItem()
                principalNavItem()
            }
        }
    }
}


extension CallTabScreen{
    @ToolbarContentBuilder
    private func leadingNavItem()->some ToolbarContent{
        ToolbarItem(placement: .topBarLeading) {
            Button{
                
            }label: {
                Text("Edit")
            }
        }
    }
    
    private func trailingNavItem()->some ToolbarContent{
        ToolbarItem(placement: .topBarTrailing) {
            Button{
                
            }label: {
                Image(systemName: "phone.arrow.up.right")
            }
        }
    }
    
    private func principalNavItem()->some ToolbarContent{
        ToolbarItem(placement: .principal) {
            Picker("", selection: $callHistory) {
                ForEach(CallHistory.allCases) { item in
                    Text(item.rawValue.capitalized)
                        .tag(item)
                }
            }
            .pickerStyle(.segmented)
            .frame(width: 150)
        }
    }
    
    
    private enum CallHistory:String,CaseIterable,Identifiable{
        case all,missed
        var id:String{
            return rawValue
        }
    }
}

private struct CreateCallLinkSection:View {
    var body: some View {
        HStack{
            Image(systemName: "link")
                .padding(8)
                .background(Color(.systemGray6))
                .clipShape(Circle())
                .foregroundStyle(.blue)
            
            VStack(alignment:.leading){
                Text("Create Call Link")
                    .foregroundStyle(.blue)
                Text("Share a link for your Whatsapp call")
                    .foregroundStyle(.gray)
                    .font(.caption)
            }
        }
    }
}

private struct RecentCallItemView:View {
    var body: some View {
        HStack{
            Circle()
                .frame(width: 45,height: 45)
            
            recentCallsTextView()
            
            Spacer()
            
            Text("Yesterday")
                .foregroundStyle(.gray)
                .font(.system(size: 16))
            Image(systemName: "info.circle")
        }
    }
    
    private func recentCallsTextView()->some View{
        VStack(alignment:.leading){
            Text("Hemanth Reddy")
            HStack(spacing:5){
                Image(systemName: "phone.arrow.up.right.fill")
                Text("Outgoing")
            }
            .font(.system(size: 14))
            .foregroundStyle(.gray)
        }

    }
}

#Preview {
    CallTabScreen()
}
