//
//  SwipeCardView.swift
//  Bloom
//
//  Created by トム・クルーズ on 2024/02/28.
//

import SwiftUI

struct SwipeView: View {
    @ObservedObject var swipeViewModel = SwipeViewModel()
    @State var profiles: [CardModel] = []
    @State var isLike: Bool? = nil
    @State var offset: CGFloat? = .zero
    
    let iconSize = UIScreen.main.bounds.width / 14
    
    var body: some View {
        NavigationStack {
            ZStack {
                ForEach(Array($profiles.enumerated()), id: \.element.id) { index, $card in
                    SwipeCardView(card: card, isLike: $isLike)
                        .offset(x: card.id == profiles.first?.id ? card.offset.width : 0,
                                y: card.id == profiles.first?.id ? card.offset.height : -CGFloat(index) * 30)
                        .scaleEffect(card.id == profiles.first?.id ? 1 : 1 - CGFloat(index) * 0.05)
                        .rotationEffect(.degrees(Double(card.offset.width) / 20), anchor: .bottom)
                        .zIndex(-Double(card.id)) // スタックの順番を制御
                        .gesture(
                            DragGesture()
                                .onChanged { gesture in
                                    if card.id == profiles.first?.id {
                                        card.offset = gesture.translation
                                    }
                                    withAnimation {
                                        if abs(gesture.translation.width) > 120 {
                                            if gesture.startLocation.x < gesture.location.x {
                                                isLike = true
                                                card.isLike = true
                                            } else if gesture.startLocation.x > gesture.location.x {
                                                isLike = false
                                                card.isLike = false
                                            }
                                        }
                                    }
                                }
                                .onEnded { gesture in
                                    withAnimation {
                                        if card.id == profiles.first?.id {
                                            if abs(gesture.translation.width) > 150 {
                                                if gesture.startLocation.x < gesture.location.x {
                                                    swipeViewModel.addFriendsToList(state: .likeByMe, friendProfile: card.profile)
                                                } else if gesture.startLocation.x > gesture.location.x {
                                                    swipeViewModel.addFriendsToList(state: .unLikeByMe, friendProfile: card.profile)
                                                }
                                                profiles.removeAll { $0.id == profiles.first?.id }
                                                isLike = nil
                                                card.isLike = nil
                                            } else {
                                                card.offset = .zero
                                                isLike = nil
                                                card.isLike = nil
                                            }
                                        }
                                    }
                                }
                        )
                }
            }
            .navigationBarTitle("Bloom", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Image(systemName: "questionmark.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: iconSize)
                        .foregroundStyle(Color.white)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Image(systemName: "slider.horizontal.3")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: iconSize)
                        .foregroundStyle(Color.white)
                }
            }
        }
        .onChange(of: swipeViewModel.friendProfiles.count) {
            profiles.removeAll()
            
            var cardId = 1
            for profile in swipeViewModel.friendProfiles {
                profiles.append(CardModel(id: cardId, profile: profile))
                cardId += 1
            }
        }
    }
}

struct CardModel: Identifiable {
    var id: Int
    let profile: ProfileElement
    var isLike: Bool? = nil
    var offset: CGSize = .zero // 各カードのオフセットを追加
    var color: Color = .white // 各カードのカラーを追加
}

#Preview {
    SwipeView()
}
