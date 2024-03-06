//
//  TalkView.swift
//  Bloom
//
//  Created by トム・クルーズ on 2024/02/24.
//

import SwiftUI

struct FriendListView: View {
    @ObservedObject var friendsListData = RegistrationViewModel()
    @ObservedObject var friendListViewModel = FriendListViewModel()
    
    var body: some View {
        NavigationStack {
            List(friendListViewModel.matchedFriendList, id: \.id) { profile in
                ZStack {
                    NavigationLink(
                        destination: MessageView(
                            chatPartnerProfile: profile
                        )
                        .toolbar(.hidden, for: .tabBar)
                    ) {}
                    .opacity(0)
                    
                    FriendListRowView(
                        chatPartnerProfile: profile
                    )
                }
            }
            .listStyle(PlainListStyle())
            .navigationTitle("トーク")
        }
    }
}

#Preview {
    FriendListView()
}
