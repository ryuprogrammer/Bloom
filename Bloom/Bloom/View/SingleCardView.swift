//
//  SingleCardView.swift
//  Bloom
//
//  Created by トム・クルーズ on 2024/02/28.
//

import SwiftUI

struct SingleCardView: View {
    var card: CardModel
    @Binding var isLike: Bool?
    
    var body: some View {
        Text(card.profile.userName)
            .font(.largeTitle)
            .frame(width: 360, height: 550)
            .background {
                if let isLike = isLike {
                    switch isLike {
                    case true: Color.pink
                    case false: Color.gray
                    }
                } else {
                    Color.cyan
                }
            }
            .cornerRadius(15)
            .padding()
            .shadow(radius: 20)
    }
}

#Preview {
    struct PreviewView: View {
        @State var isLike: Bool? = nil
        var body: some View {
            SingleCardView(
                card: CardModel(
                    id: 1,
                    profile: ProfileElement(
                        userName: "もも",
                        birth: "",
                        gender: .men,
                        address: "栃木県",
                        profileImages: [],
                        homeImage: Data()
                    )
                ),
                isLike: $isLike
            )
        }
    }
    
    return PreviewView()
}
