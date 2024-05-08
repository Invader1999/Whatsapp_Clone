//
//  UpdatesTabScreen.swift
//  Whatsapp_Clone
//
//  Created by Kareddy Hemanth Reddy on 23/04/24.
//

import SwiftUI

struct UpdatesTabScreen: View {
    @State private var searchText = ""
    var body: some View {
        NavigationStack{
            List{
                StatusSectionHeader()
                    .listRowBackground(Color.clear)
                
                StatusSection()
                
                Section{
                    RecentUpdatesItemView()
                    
                }header: {
                 Text("Recent Updates")
                }
                
                
                Section {
                    ChannelListView()
                    
                } header: {
                    channelSectionHeader()
                }
            }
            .listStyle(.grouped)
            .navigationTitle("Updates")
            .searchable(text: $searchText)
        }
    }
    
    private func channelSectionHeader()->some View{
        HStack{
            Text("Channels")
                .bold()
                .font(.title3)
                .textCase(nil)
                .foregroundStyle(.whatsAppBlack)
            
            Spacer()
            Button{
                
            }label: {
                Image(systemName: "plus")
                    .padding(7)
                    .background(Color(.systemGray5))
                    .clipShape(Circle())
            }
        }
    }
}
extension UpdatesTabScreen{
    enum Constants{
        static let imageDimension:CGFloat = 55
    }
}

private struct StatusSectionHeader:View {
    var body: some View {
        HStack(alignment:.top){
            Image(systemName: "circle.dashed")
                .foregroundStyle(.blue)
                .imageScale(.large)
            (
            Text("Use Status to share photos, text and videos that disspear in 24 hours.")
            +
            Text(" ")
            +
            Text("Status Privacy")
                .foregroundStyle(.blue).bold()
            )
            
            Image(systemName: "xmark")
                .foregroundStyle(.gray)
        }
        .padding()
        .background(.whatsAppWhite)
        .clipShape(RoundedRectangle(cornerRadius: 10,style: .continuous))
    }
}



private struct StatusSection:View {
    var body: some View {
        HStack{
            Circle()
                .frame(width: UpdatesTabScreen.Constants.imageDimension,height: UpdatesTabScreen.Constants.imageDimension)
            
            VStack(alignment: .leading){
                Text("My Status")
                    .font(.callout)
                    .bold()
                
                Text("Add to my status")
                    .foregroundStyle(.gray)
                    .font(.system(size: 15))
            }
            
            Spacer()
            
            cameraButton()
            pencilButton()
        }
    }
    
    
    private func cameraButton()->some View{
        Button{
            
        }label: {
            Image(systemName: "camera.fill")
                .padding(10)
                .background(Color(.systemGray5))
                .clipShape(Circle())
                .bold()
        }
    }
    
    
    private func pencilButton()->some View{
        Button{
            
        }label: {
            Image(systemName: "pencil")
                .padding(10)
                .background(Color(.systemGray5))
                .clipShape(Circle())
                .bold()
        }
    }
}


private struct RecentUpdatesItemView:View {
    var body: some View {
        HStack{
        Circle()
            .frame(width: UpdatesTabScreen.Constants.imageDimension,height: UpdatesTabScreen.Constants.imageDimension)
            
            VStack(alignment: .leading){
                Text("Hemanth Reddy")
                    .font(.callout)
                    .bold()
                
                Text("1h ago")
                    .foregroundStyle(.gray)
                    .font(.system(size: 15))
            }
        }
    }
}

private struct ChannelListView:View {
    var body: some View {
        VStack(alignment:.leading){
            Text("Stay updated on topics that matter to you. Find channels you follow")
                .foregroundStyle(.gray)
                .font(.callout)
                .padding(.horizontal)
            
            
            ScrollView(.horizontal,showsIndicators: false) {
                HStack{
                    ForEach(0..<5) { _ in
                        ChannelItemView()
                    }
                }
            }
            
            Button("Explore More"){}
                .tint(.blue)
                .bold()
                .buttonStyle(.borderedProminent)
                .clipShape(Capsule())
                .padding(.vertical)
        }
    }
}

private struct ChannelItemView:View {
    var body: some View {
        VStack{
            Circle()
                .frame(width: 55,height: 55)
            
            Text("MoneyControl")
            
            Button{
                
            }label: {
                Text("Follow")
                    .bold()
                    .padding(5)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue.opacity(0.2))
                    .clipShape(Capsule())
            }
        }
        .padding(.horizontal,16)
        .padding(.vertical)
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(.systemGray4),lineWidth: 1)
        }
    }
}

#Preview {
    UpdatesTabScreen()
}
