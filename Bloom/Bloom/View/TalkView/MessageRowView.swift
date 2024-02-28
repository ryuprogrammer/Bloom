//
//  MessageRowView.swift
//  Bloom
//
//  Created by トム・クルーズ on 2024/02/22.
//

import SwiftUI

struct MessageRowView: View {
    let message: MessageElement
    let isMyMessage: Bool
    
    var body: some View {
        HStack {
            if isMyMessage { // 自分
                Spacer()
                
                Text(message.message)
                    .padding(10)
                    .background(Color.cyan)
                    .cornerRadius(20)
                    .foregroundColor(Color.white)
            } else { // 相手
                Text(message.message)
                    .padding(10)
                    .background(Color.pink.opacity(0.7))
                    .cornerRadius(20)
                    .foregroundColor(Color.white)
                
                Spacer()
            }
        }
    }
}

#Preview {
    VStack {
        MessageRowView(
            message: MessageElement(
                uid: "sss",
                roomID: "roomID",
                isNewMessage: true, name: "userName",
                message: "メッセージ",
                createAt: Date()
            ),
            isMyMessage: true
        )
        
        MessageRowView(
            message: MessageElement(
                uid: "sss",
                roomID: "roomID",
                isNewMessage: true, name: "userName",
                message: "メッセージ",
                createAt: Date()
            ),
            isMyMessage: true
        )
    }
}
