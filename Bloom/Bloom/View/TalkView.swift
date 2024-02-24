//
//  TalkView.swift
//  Bloom
//
//  Created by トム・クルーズ on 2024/02/24.
//

import SwiftUI

struct TalkView: View {
    @ObservedObject var friendsListData = RegistrationViewModel()
    var body: some View {
        List(friendsListData.profiles, id: \.id) { profile in
            Text(profile.userName)
        }
    }
}

#Preview {
    TalkView()
}
