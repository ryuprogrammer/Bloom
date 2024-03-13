//
//  SwipeCardView.swift
//  Bloom
//
//  Created by トム・クルーズ on 2024/02/28.
//

import SwiftUI
import SwiftData

struct SwipeView: View {
    // MARK: - SwiftData用
    @Environment(\.modelContext) private var context
    @Query private var swipeFriendElement: [SwipeFriendElement]
    
    @ObservedObject var swipeViewModel = SwipeViewModel()
    @State var showingCard: [CardModel] = []
    @State var offset: CGFloat? = .zero
    
    let iconSize = UIScreen.main.bounds.width / 14
    @State var cardId: Int = 0
    
    var body: some View {
        NavigationStack {
            ZStack {
                ForEach(Array($showingCard.enumerated()), id: \.element.id) { index, $card in
                    SwipeCardView(card: card)
                        .offset(x: card.id == showingCard.first?.id ? card.offset.width : 0,
                                y: card.id == showingCard.first?.id ? card.offset.height : -CGFloat(index) * 30)
                        .scaleEffect(card.id == showingCard.first?.id ? 1 : 1 - CGFloat(index) * 0.05)
                        .rotationEffect(.degrees(Double(card.offset.width) / 20), anchor: .bottom)
                        .zIndex(-Double(card.id)) // スタックの順番を制御
                        .gesture(
                            DragGesture()
                                .onChanged { gesture in
                                    guard let firstCard = showingCard.first,
                                          card.id == firstCard.id else { return }
                                    let translation = gesture.translation
                                    card.offset = translation
                                    withAnimation {
                                        if abs(translation.width) > 80 {
                                            if gesture.startLocation.x < gesture.location.x {
                                                card.isLike = true
                                            } else if gesture.startLocation.x > gesture.location.x {
                                                card.isLike = false
                                            }
                                        }
                                    }
                                }
                                .onEnded { gesture in
                                    guard let firstCard = showingCard.first, card.id == firstCard.id else { return }
                                    let translation = gesture.translation
                                    withAnimation {
                                        if abs(translation.width) > 150 {
                                            if gesture.startLocation.x < gesture.location.x {
                                                swipeViewModel.addFriendsToList(state: .likeByMe, friendProfile: card.profile)
                                            } else if gesture.startLocation.x > gesture.location.x {
                                                swipeViewModel.addFriendsToList(state: .unLikeByMe, friendProfile: card.profile)
                                            }
                                            // SwiftDataから削除
                                            swipeViewModel.deleteSwipeFriendElement(
                                                context: context,
                                                swipeFriendElement: SwipeFriendElement(
                                                    profile: card.profile.toMyProfileElement()
                                                )
                                            )
                                            showingCard.removeAll { $0.id == firstCard.id }
                                        } else {
                                            card.isLike = nil
                                            card.offset = .zero
                                        }
                                    }
                                }
                        )
                }
            }
            .navigationBarTitle("スワイプしよう！", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Image(systemName: "questionmark.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: iconSize)
                        .foregroundStyle(Color.white)
                        .onTapGesture {
                            swipeViewModel.deleteAllSwipeFriendElement(context: context)
                        }
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
            cardId = swipeFriendElement.count
            
            for profile in swipeViewModel.friendProfiles {
                // swiftDataに保存
                swipeViewModel.addSwipeFriendElement(
                    context: context,
                    swipeFriendElement: SwipeFriendElement(
                        profile: profile.toMyProfileElement()
                    )
                )
                showingCard.append(CardModel(id: cardId, profile: profile))
                cardId += 1
            }
        }
        .onChange(of: swipeFriendElement) {
            // 20以下になったら追加する
            if swipeFriendElement.count < 3 {
                swipeViewModel.fetchSignInUser()
            }
        }
        .onAppear {
            if swipeFriendElement.count >= 5 {
                cardId = swipeFriendElement.count
                for friendElement in swipeFriendElement {
                    showingCard.append(CardModel(
                        id: cardId,
                        profile: friendElement.profile.toProfileElement()
                    ))
                    cardId += 1
                }
            } else {
                // データ取得
                swipeViewModel.fetchSignInUser()
            }
        }
    }
}

struct CardModel: Identifiable {
    var id: Int
    let profile: ProfileElement
    var isLike: Bool? = nil
    var offset: CGSize = .zero // 各カードのオフセットを追加
}

#Preview {
    SwipeView()
}
