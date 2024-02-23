//
//  MessageRowView.swift
//  Bloom
//
//  Created by トム・クルーズ on 2024/02/22.
//

import SwiftUI

struct MessageRowView: View {
    let message: String
    let isMyMessage: Bool
    let user: String
    let date: Date
    
    var body: some View {
        HStack {
            if isMyMessage {
                Spacer()
                
                VStack {
                    Text(message)
                        .padding(10)
                        .background(Color.red)
                        .cornerRadius(15)
                        .foregroundColor(Color.white)
                    Text(date.description)
                        .font(.callout)
                }
            } else {
                VStack(alignment: .leading) {
                    Text(message)
                        .padding(10)
                        .background(Color.green)
                        .cornerRadius(15)
                        .foregroundColor(Color.white)
                    
                    HStack {
                        Text(user)
                        
                        Text(date.description)
                            .font(.callout)
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
        }
    }
}

#Preview {
    MessageRowView(
        message: "メッセージ",
        isMyMessage: false,
        user: "もも",
        date: Date()
    )
}
