//
//  FriendPreviewView.swift
//  Bloom
//
//  Created by トム・クルーズ on 2024/03/09.
//

import SwiftUI

struct FriendPreviewView: View {
    
    @State var profile = ProfileElement(
        userName: "もも",
        introduction: "自己紹介文自己紹介文自己紹介",
        birth: "20000421",
        gender: .men,
        address: "栃木県🍓",
        profileImages: [Data(), Data(), Data(), Data()],
        homeImage: Data()
    )
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    FriendPreviewView()
}
