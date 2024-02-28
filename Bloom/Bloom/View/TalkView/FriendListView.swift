//
//  TalkView.swift
//  Bloom
//
//  Created by トム・クルーズ on 2024/02/24.
//

import SwiftUI

struct FriendListView: View {
    var messageVM = MessageViewModel()
    @ObservedObject var friendsListData = RegistrationViewModel()
    @ObservedObject var friendListViewModel = FriendListViewModel()
    /// Mockデータ
    let mockData = MockData()
    
    var body: some View {
        NavigationStack {
            List(friendsListData.friendProfiles, id: \.id) { profile in
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
