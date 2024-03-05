//
//  FriendListRowView.swift
//  Bloom
//
//  Created by トム・クルーズ on 2024/02/27.
//

import SwiftUI

struct FriendListRowView: View {
    let chatPartnerProfile: ProfileElement
    @ObservedObject var friendListViewModel = FriendListViewModel()
    @ObservedObject var messageVM = MessageViewModel()
    @State var newMessageCount: Int = 3
    @State var lastMessage: String = "最長文字数に挑戦最長文字数に挑戦最長文ahdjjkdf"
    let mostLongStringNumber: Int = 16
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(chatPartnerProfile.userName)
                    .font(.title2)
                
                Text(lastMessage)
                    .font(.callout)
            }
            .padding(.horizontal)
            
            Spacer()
            
            if newMessageCount != 0 {
                Text(String(newMessageCount))
                    .font(.title3)
                    .frame(width: 30, height: 30)
                    .foregroundStyle(Color.white)
                    .background(Color.pink.opacity(0.8))
                    .clipShape(Circle())
                    .padding(.horizontal)
            }
        }
        .onChange(of: messageVM.messages) {
            Task {
                await friendListViewModel.fetchNewMessageCountAll(chatPartnerProfile: chatPartnerProfile)
            }
            if let message = messageVM.messages.last {
                lastMessage = friendListViewModel.adjustStringLengths(message: message.message)
            }
            newMessageCount = friendListViewModel.newMessageCount
        }
        .onAppear {
            Task {
                await friendListViewModel.fetchNewMessageCountAll(chatPartnerProfile: chatPartnerProfile)
            }
//            friendListViewModel.fetchNewMessageCount(chatPartnerProfile: chatPartnerProfile)
            messageVM.fetchRoomIDMessages(chatPartnerProfile: chatPartnerProfile)
            newMessageCount = friendListViewModel.newMessageCount
            
            if let message = messageVM.messages.last {
                lastMessage = friendListViewModel.adjustStringLengths(message: message.message)
            }
        }
    }
}

#Preview {
    VStack {
        FriendListRowView(
            chatPartnerProfile: ProfileElement(
                userName: "もも",
                introduction: "",
                birth: "",
                gender: .men,
                address: "栃木県",
                profileImages: [],
                homeImage: Data()
            )
        )
        
        FriendListRowView(
            chatPartnerProfile: ProfileElement(
                userName: "もも",
                introduction: "",
                birth: "",
                gender: .men,
                address: "栃木県",
                profileImages: [],
                homeImage: Data()
            )
        )
    }
}
