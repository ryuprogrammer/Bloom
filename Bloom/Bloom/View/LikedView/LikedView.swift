//
//  LikedView.swift
//  Bloom
//
//  Created by トム・クルーズ on 2024/03/07.
//

import SwiftUI

struct LikedView: View {
    @ObservedObject var swipeViewModel = SwipeViewModel()
    @State var profiles: [LikedCardModel] = []
    @State var isLike: Bool? = nil
    @State var offset: CGFloat? = .zero
    
    let iconSize = UIScreen.main.bounds.width / 14
    private var columns: [GridItem] = Array(repeating: .init(.flexible(), spacing: 20), count: 2)
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach($profiles) { $card in
                        LikedCardView(card: card)
                            .offset(x: card.offset.width, y: card.offset.height)
                            .rotationEffect(.degrees(Double(card.offset.width) / 20), anchor: .bottom)
                            .zIndex(card.isDragging ? 1 : 0)
                            .gesture(
                                DragGesture()
                                    .onChanged { gesture in
                                        card.offset = gesture.translation
                                        card.isDragging = true
                                        withAnimation {
                                            if abs(gesture.translation.width) > 120 {
                                                if gesture.startLocation.x < gesture.location.x {
                                                    isLike = true
                                                } else if gesture.startLocation.x > gesture.location.x {
                                                    isLike = false
                                                }
                                            }
                                        }
                                    }
                                    .onEnded { gesture in
                                        withAnimation {
                                            if abs(gesture.translation.width) > 150 {
                                                if gesture.startLocation.x < gesture.location.x {
                                                    swipeViewModel.addFriendsToList(state: .likeByMe, friendProfile: card.profile)
                                                } else if gesture.startLocation.x > gesture.location.x {
                                                    swipeViewModel.addFriendsToList(state: .unLikeByMe, friendProfile: card.profile)
                                                }
                                                profiles.removeAll { $0.id == card.id }
                                                isLike = nil
                                            } else {
                                                card.offset = .zero
                                                isLike = nil
                                            }
                                        }
                                        card.isDragging = false
                                    }
                            )
                    }
                }
            }
            .navigationBarTitle("いいねしてくれた友達", displayMode: .inline)
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
                profiles.append(LikedCardModel(id: cardId, profile: profile))
                cardId += 1
            }
        }
    }
}

struct LikedCardModel: Identifiable {
    var id: Int
    var profile: ProfileElement
    var offset: CGSize = .zero
    var isDragging: Bool = false
}

#Preview {
    LikedView()
}
