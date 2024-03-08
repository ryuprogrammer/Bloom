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
    @State var newMessageCount: Int = 0
    @State var lastMessage: String = "メッセージをはじめよう！"
    let mostLongStringNumber: Int = 16
    
    // 画面横幅取得→写真の横幅と縦幅に利用
    let imageSize = UIScreen.main.bounds.width / 6
    let viewHeight = UIScreen.main.bounds.height / 10

    var body: some View {
        HStack {
            DataImage(dataImage: chatPartnerProfile.homeImage)
                .aspectRatio(contentMode: .fill)
                .frame(width: imageSize, height: imageSize)
                .clipShape(Circle())
                .padding(.horizontal, 8)
            
            VStack(alignment: .leading) {
                Spacer()
                
                HStack(alignment: .bottom) {
                    Text(chatPartnerProfile.userName)
                        .foregroundStyle(Color.black)
                        .font(.title)
                        .fontWeight(.semibold)
                    
                    Text(chatPartnerProfile.birth.toAge() + "・" + chatPartnerProfile.address)
                        .foregroundStyle(Color.black)
                        .font(.title3)
                }
                
                Spacer()
                
                Text(lastMessage)
                    .font(.callout)
                    .foregroundStyle(Color.gray)
                    .lineLimit(1)
                
                Spacer()
            }
            
            Spacer()
            
            // 新規メッセージの数
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
        .frame(height: viewHeight)
        .onChange(of: messageVM.messages) {
            Task {
                await friendListViewModel.fetchNewMessageCountAll(chatPartnerProfile: chatPartnerProfile)
            }
            if let message = messageVM.messages.last {
                lastMessage = message.message
            }
            newMessageCount = friendListViewModel.newMessageCount
        }
        .onAppear {
            Task {
                await friendListViewModel.fetchNewMessageCountAll(chatPartnerProfile: chatPartnerProfile)
            }
            // RoomIDを指定して、メッセージを取得
            messageVM.fetchRoomIDMessages(chatPartnerProfile: chatPartnerProfile)
            // 新規メッセージの数を取得
            newMessageCount = friendListViewModel.newMessageCount
            // 最新のメッセージをListに表示
            if let message = messageVM.messages.last {
                lastMessage = message.message
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
