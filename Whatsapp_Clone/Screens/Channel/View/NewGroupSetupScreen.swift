//
//  NewGroupSetupScreen.swift
//  Whatsapp_Clone
//
//  Created by Kareddy Hemanth Reddy on 11/05/24.
//

import SwiftUI

struct NewGroupSetupScreen: View {
    @State private var channelName:String = ""
    @ObservedObject var viewModel:ChatPartnerPickerViewModel
    var onCreate:(_ newChannel:ChannelItem) -> Void
    var body: some View {
        List{
            Section {
                channelSetupHeaderView()
            }
            Section{
                Text("Disappearing Messages")
                Text("Group permissions")
            }
            
            Section{
                SelectedChatPartnerView(users: viewModel.selectedChatPartners) { user in
                    viewModel.handleItemSelection(user)
                }
            }header: {
                let count = viewModel.selectedChatPartners.count
                let maxCount = ChannelConstants.maximumGroupParticipants
               
                Text("Participants: \(count) of \(maxCount)")
                    .bold()
            }
            .listRowBackground(Color.clear)
           
        }
        .navigationTitle("New Group")
        .toolbar{
            trailingNavItem()
        }
    }
    
    private func channelSetupHeaderView()-> some View{
        HStack{
           profileImageView()
            
            TextField("", text: $channelName,prompt: Text("Group name (optional)"),axis: .vertical)
        }
    }
    
    private func profileImageView()-> some View{
        Button{
            
        }label:{
            ZStack{
                    Image(systemName: "camera.fill")
                    .imageScale(.large)
            }
            .frame(width: 60,height: 60)
            .background(Color(.systemGray6))
            .clipShape(Circle())
        }
    }
    
    @ToolbarContentBuilder
    private func trailingNavItem()->some ToolbarContent{
        ToolbarItem(placement: .topBarTrailing) {
            Button("Create"){
                if viewModel.isDirectChannel{
                    guard let chatPartner = viewModel.selectedChatPartners.first else {return}
                    viewModel.createDirectChannel(chatPartner, completion: onCreate)
                }else{
                    viewModel.createGroupChannel(channelName, completion: onCreate)
                }
            }
            .bold()
            .disabled(viewModel.disableNextItem)
        }
    }
    
}

#Preview {
    NavigationStack{
        NewGroupSetupScreen(viewModel: ChatPartnerPickerViewModel()){_ in
            
        }
    }
}
