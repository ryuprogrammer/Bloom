//
//  MessageView.swift
//  Bloom
//
//  Created by トム・クルーズ on 2024/02/24.
//

import SwiftUI

struct MessageView: View {
    let name: String
    
    var messageVM = MessageViewModel()
    @State private var typeMessage = ""
    
    var body: some View {
        VStack {
            List(messageVM.messages, id: \.id) {message in
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
            .navigationBarTitle("チャット", displayMode: .inline)
            
            HStack {
                TextField("メッセージを入力", text: $typeMessage)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: {
                    messageVM.addMessage(
                        message: typeMessage,
                        name: name
                    )
                }, label: {
                    Image(systemName: "arrow.up.circle.fill")
                })
            }
            .padding()
        }
    }
}

#Preview {
    MessageView(name: "もも")
}
