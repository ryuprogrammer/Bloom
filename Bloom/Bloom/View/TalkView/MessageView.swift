//
//  MessageView.swift
//  Bloom
//
//  Created by トム・クルーズ on 2024/02/24.
//

import SwiftUI

struct MessageView: View {
    let name: String
    let chatPartnerProfile: ProfileElement?
    
    @ObservedObject var messageVM = MessageViewModel()
    @State private var typeMessage = ""
    
    var body: some View {
        VStack {
            ScrollViewReader { proxy in
                List(messageVM.messages, id: \.listId) {message in
                    if message.name == name {
                        MessageRowView(
                            message: message.message,
                            isMyMessage: true,
                            user: message.name,
                            date: message.createAt
                        )
                    } else {
                        MessageRowView(
                            message: message.message,
                            isMyMessage: false,
                            user: message.name,
                            date: message.createAt
                        )
                    }
                }
                .listStyle(PlainListStyle())
                .navigationBarTitle(chatPartnerProfile?.userName ?? "Chat", displayMode: .inline)
                .onChange(of: messageVM.messages) {
                    withAnimation {
                        print("スクローーーーる")
                        proxy.scrollTo(messageVM.messages.last, anchor: .bottom)
                    }
                }
            }
            
            HStack {
                TextField("メッセージを入力", text: $typeMessage)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: {
                    Task {
                        guard let chatPartnerProfile = chatPartnerProfile else { return }
                        
                        // メッセージ追加
                        await messageVM.addMessage(
                            chatPartnerProfile: chatPartnerProfile,
                            message: typeMessage
                        )
                    }
                }, label: {
                    Image(systemName: "arrow.up.circle.fill")
                })
            }
            .padding()
        }
        .onAppear {
            guard let chatPartnerProfile = chatPartnerProfile else { return }
            // chatPartnerProfileからmessagesを取得
            messageVM.fetchRoomIDMessages(chatPartnerProfile: chatPartnerProfile)
            print("messages: \(messageVM.messages)")
        }
    }
}

//#Preview {
//    MessageView(name: "もも", chatPartnerProfile: ProfileElement?)
//}
