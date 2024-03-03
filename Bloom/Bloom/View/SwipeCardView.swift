//
//  SwipeCardView.swift
//  Bloom
//
//  Created by トム・クルーズ on 2024/02/28.
//

import SwiftUI

struct SwipeCardView: View {
    @ObservedObject var swipeViewModel = SwipeViewModel()
    @State var profiles: [CardModel] = []
    @State var isLike: Bool? = nil
    @State var offset: CGFloat? = .zero

    var body: some View {
        ZStack {
            ForEach($profiles) { $card in // $を使用してバインディングを渡します
                SingleCardView(card: card, isLike: $isLike)
                    .offset(
                        x: card.id == profiles.last?.id ? card.offset.width : 0,
                        y: card.id == profiles.last?.id ? card.offset.height : 0
                    )
                    .rotationEffect(.degrees(Double(card.offset.width) / 20), anchor: .bottom)
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                if card.id == profiles.last?.id {
                                    card.offset = gesture.translation
                                }
                                withAnimation {
                                    if abs(gesture.translation.width) > 120 {
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
                                    if card.id == profiles.last?.id {
                                        if abs(gesture.translation.width) > 150 {
                                            if gesture.startLocation.x < gesture.location.x {
                                                // データ追加
                                                swipeViewModel.addFriendsToList(
                                                    state: .likeByMe,
                                                    friendProfile: card.profile
                                                )
                                            } else if gesture.startLocation.x > gesture.location.x {
                                                // データ追加
                                                swipeViewModel.addFriendsToList(
                                                    state: .unLikeByMe,
                                                    friendProfile: card.profile
                                                )
                                            }
                                            // スワイプ距離が100を超えた場合、カードを削除
                                            profiles.removeAll { $0.id == card.id }
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
        .onChange(of: swipeViewModel.friendProfiles.count) {
            profiles.removeAll()
            
            var cardId = 1
            for profile in swipeViewModel.friendProfiles {
                print("onChangeで取得")
                profiles.append(
                    CardModel(id: cardId, profile: profile)
                )
                cardId += 1
            }
        }
    }
}

struct CardModel: Identifiable {
    var id: Int
    let profile: ProfileElement
    var offset: CGSize = .zero // 各カードのオフセットを追加
    var color: Color = .white // 各カードのカラーを追加
}

struct CardModel2: Identifiable {
    var id: Int
    let name: String
    let image: String
    var offset: CGSize = .zero // 各カードのオフセットを追加
}

#Preview {
    SwipeCardView()
}
