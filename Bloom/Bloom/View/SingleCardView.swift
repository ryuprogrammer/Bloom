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
        Text(card.image)
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

struct CardModel: Identifiable {
    var id: Int
    let name: String
    let image: String
    var offset: CGSize = .zero // 各カードのオフセットを追加
}


#Preview {
    struct PreviewView: View {
        @State var isLike: Bool? = nil
        var body: some View {
            SingleCardView(
                card: CardModel(id: 1, name: "a", image: "りゅう"),
                           isLike: $isLike
            )
        }
    }
    
    return PreviewView()
}
