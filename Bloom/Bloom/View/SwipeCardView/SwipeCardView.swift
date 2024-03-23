//
//  SwipeCardView.swift
//  Bloom
//
//  Created by トム・クルーズ on 2024/02/28.
//

import SwiftUI

struct SwipeCardView: View {
    @State private var cardModels = [
        CardModel(id: 1, name: "Name1", image: "image1"),
        CardModel(id: 2, name: "Name2", image: "image2"),
        CardModel(id: 3, name: "Name1", image: "image1"),
        CardModel(id: 4, name: "Name2", image: "image2"),
        CardModel(id: 5, name: "Name1", image: "image1"),
        CardModel(id: 6, name: "Name2", image: "image2"),
        CardModel(id: 7, name: "Name1", image: "image1"),
        CardModel(id: 8, name: "Name2", image: "image2")
    ]
    @State var isLike: Bool? = nil

    var body: some View {
        ZStack {
            ForEach($cardModels) { $card in // $を使用してバインディングを渡します
                SingleCardView(card: card, isLike: $isLike)
                    .offset(
                        x: card.id == cardModels.last?.id ? card.offset.width : 0,
                        y: card.id == cardModels.last?.id ? card.offset.height : 0
                    )
                    .rotationEffect(.degrees(Double(card.offset.width) / 20), anchor: .bottom)
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                if card.id == cardModels.last?.id {
                                    card.offset = gesture.translation
                                }
                                withAnimation {
                                    if abs(gesture.translation.width) > 150 {
                                        if gesture.startLocation.x < gesture.location.x {
                                            isLike = true
                                        } else if gesture.startLocation.x > gesture.location.x {
                                            isLike = false
                                        } else {
                                            isLike = nil
                                        }
                                    }
                                }
                            }
                            .onEnded { gesture in
                                withAnimation {
                                    if card.id == cardModels.last?.id {
                                        if abs(gesture.translation.width) > 150 {
                                            // スワイプ距離が100を超えた場合、カードを削除
                                            cardModels.removeAll { $0.id == card.id }
                                            isLike = nil
                                        } else {
                                            // スワイプが終了したらオフセットをリセット
                                            card.offset = .zero
                                            isLike = nil
                                        }
                                    }
                                }
                            }
                    )
            }
        }
    }
}

#Preview {
    SwipeCardView()
}
