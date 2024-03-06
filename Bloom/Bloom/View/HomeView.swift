//
//  HomeView.swift
//  Bloom
//
//  Created by トム・クルーズ on 2024/02/24.
//

import SwiftUI

struct HomeView: View {
    /// タブの選択項目を保持する
    @State var selection = 3
    
    init() {
          // 背景色
          UITabBar.appearance().backgroundColor = .white
    }
    
    var body: some View {
        TabView(selection: $selection) {
            SwipeView()
                .tabItem {
                    VStack {
                        Image(systemName: "person.crop.rectangle.stack")
                        Text("スワイプ")
                    }
                }
                .tag(1)
            
            LikedView()
                .tabItem {
                    VStack {
                        Image(systemName: "heart")
                        Text("いいね")
                    }
                }
                .tag(2)
            
            FriendListView()
                .tabItem {
                    VStack {
                        Image(systemName: "message")
                        Text("トーク")
                    }
                }
                .tag(3)
                .badge(5)
            
            Text("Tab Content 2")
                .tabItem {
                    VStack {
                        Image(systemName: "person.fill")
                        Text("ホーム")
                    }
                }
                .tag(4)
        }
    }
}

#Preview {
    HomeView()
}
