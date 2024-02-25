//
//  TalkView.swift
//  Bloom
//
//  Created by トム・クルーズ on 2024/02/24.
//

import SwiftUI

struct TalkView: View {
    var messageVM = MessageViewModel()
    @ObservedObject var friendsListData = RegistrationViewModel()
    @State var myProfile: ProfileElement? = nil
    /// Mockデータ
    let mockData = MockData()
    
    var body: some View {
        NavigationStack {
            List(friendsListData.friendProfiles, id: \.id) { profile in
                NavigationLink(profile.userName) {
                    MessageView(
                        name: profile.userName,
                        chatPartnerProfile: profile
                    )
                }
            }
            .listStyle(PlainListStyle())
            .navigationTitle("トーク")
        }
        .onAppear {
            Task {
                do {
                    myProfile = try await messageVM.fetchProfile()
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }

}

#Preview {
    TalkView()
}
