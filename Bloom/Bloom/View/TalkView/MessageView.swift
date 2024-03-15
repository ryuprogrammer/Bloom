//
//  MessageView.swift
//  Bloom
//
//  Created by トム・クルーズ on 2024/02/24.
//

import SwiftUI

struct MessageView: View {
    let chatPartnerProfile: ProfileElement
    @ObservedObject var messageVM = MessageViewModel()
    @State private var typeMessage = ""
    @State private var isSendMessage: Bool = false
    @State private var sendButtonAnimate: Bool = false
    @FocusState private var keybordFocus: Bool
    @State var isShowProfile: Bool = false
    
    var body: some View {
        VStack {
            ScrollViewReader { proxy in
                List(messageVM.messages, id: \.id) { message in
                    if message.name == chatPartnerProfile.userName { // 相手のメッセージ
                        MessageRowView(
                            message: message,
                            isMyMessage: false,
                            friendProfile: chatPartnerProfile
                        )
                        .listRowSeparator(.hidden)
                    } else { // 自分のメッセージ
                        MessageRowView(
                            message: message,
                            isMyMessage: true,
                            friendProfile: nil
                        )
                        .listRowSeparator(.hidden)
                    }
                }
                .listStyle(PlainListStyle())
                .navigationBarTitle(chatPartnerProfile.userName, displayMode: .inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text(chatPartnerProfile.userName)
                            .foregroundStyle(Color.white)
                            .onTapGesture {
                                isShowProfile = true
                            }
                            .sheet(isPresented: $isShowProfile) {
                                FriendPreviewView(
                                    profile: chatPartnerProfile
                                )
                            }
                    }
                }
                .onChange(of: messageVM.messages) {
                    withAnimation {
                        if let lastMessage = messageVM.messages.last {
                            proxy.scrollTo(lastMessage.id, anchor: .bottom)
                        }
                    }
                }
            }
            
            HStack {
                TextField("メッセージを入力", text: $typeMessage)
                    .padding(.horizontal)
                    .frame(height: 35)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.cyan, lineWidth: 1)
                    )
                    .focused(self.$keybordFocus)
                    .onChange(of: typeMessage) {
                        if typeMessage != "" {
                            isSendMessage = true
                        } else {
                            isSendMessage = false
                        }
                    }
                
                Button(action: {
                    if isSendMessage {
                        sendButtonAnimate.toggle()
                        
                        // メッセージ追加
                        messageVM.addMessage(
                            chatPartnerProfile: chatPartnerProfile,
                            message: typeMessage
                        )
                        typeMessage = ""
                        keybordFocus = false
                    }
                }, label: {
                    Image(systemName: "paperplane.circle.fill")
                        .resizable()
                        .frame(width: 32, height: 32)
                        .symbolEffect(.bounce.down.byLayer, value: sendButtonAnimate)
                })
                .disabled(!isSendMessage)
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
        }
        .onAppear {
            Task {
                await messageVM.fetchMessages(chatPartnerProfile: chatPartnerProfile)
                await messageVM.changeMessage(chatPartnerProfile: chatPartnerProfile)
            }
            
            // chatPartnerProfileからmessagesを取得
            messageVM.fetchRoomIDMessages(chatPartnerProfile: chatPartnerProfile)
        }
    }
}

#Preview {
    MessageView(
        chatPartnerProfile:
            ProfileElement(
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
