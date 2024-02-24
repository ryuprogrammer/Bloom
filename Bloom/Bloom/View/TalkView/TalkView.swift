//
//  TalkView.swift
//  Bloom
//
//  Created by トム・クルーズ on 2024/02/24.
//

import SwiftUI

struct TalkView: View {
    @ObservedObject var friendsListData = RegistrationViewModel()
    /// Mockデータ
    let mockData = MockData()
    
//    var body: some View {
//        List(friendsListData.profiles, id: \.id) { profile in
//            Text(profile.userName)
//        }
//    }
//    var body: some View {
//        NavigationStack {
//            List(mockData.mockUserProfiles, id: \.id) { profile in
//                NavigationLink(profile.userName) {
//                    MessageView(name: profile.userName)
//                }
//            }
//            .listStyle(PlainListStyle())
//            .navigationTitle("トーク")
//        }
//    }
    
    var body: some View {
        NavigationStack {
            List(friendsListData.profiles, id: \.id) { profile in
                NavigationLink(profile.userName) {
                    MessageView(name: profile.userName)
                }
            }
            .listStyle(PlainListStyle())
            .navigationTitle("トーク")
        }
    }

}

#Preview {
    TalkView()
}
