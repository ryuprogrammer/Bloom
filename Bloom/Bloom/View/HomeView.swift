//
//  HomeView.swift
//  Bloom
//
//  Created by トム・クルーズ on 2024/02/24.
//

import SwiftUI

struct HomeView: View {
    /// タブの選択項目を保持する
    @State var selection: ViewSection = .swipeView
    
    enum ViewSection: Int {
        case swipeView = 1
        case likedView = 2
        case friendListView = 3
        case myPageView = 4
    }
    
    init() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = .white
        
        // タブ選択時のテキスト設定
        tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor(.pink.opacity(0.8)), .font: UIFont.systemFont(ofSize: 10, weight: .bold)]
        // タブ選択時のアイコン設定
        tabBarAppearance.stackedLayoutAppearance.selected.iconColor = UIColor(.pink.opacity(0.8))
        
        // タブ非選択時のテキスト設定
        tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor(.black.opacity(0.7)), .font: UIFont.systemFont(ofSize: 10, weight: .medium)]
        // タブ非選択時のアイコン設定
        tabBarAppearance.stackedLayoutAppearance.normal.iconColor = UIColor(.black.opacity(0.7))
        
        UITabBar.appearance().standardAppearance = tabBarAppearance
        if #available(iOS 15.0, *) {
          UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
        UITabBar.appearance().barTintColor = .green
    }
    
    var body: some View {
        TabView(selection: $selection) {
            SwipeView()
                .tabItem {
                    VStack {
                        Image(systemName: "person.crop.rectangle.stack")
                            .environment(\.symbolVariants, selection == .swipeView ? .fill : .none)
                        Text("スワイプ")
                    }
                }
                .tag(ViewSection.swipeView)
            
            LikedView()
                .tabItem {
                    VStack {
                        Image(systemName: "heart")
                            .environment(\.symbolVariants, selection == .likedView ? .fill : .none)
                        Text("いいね")
                    }
                }
                .tag(ViewSection.likedView)
            
            FriendListView()
                .tabItem {
                    VStack {
                        Image(systemName: "ellipsis.message")
                            .environment(\.symbolVariants, selection == .friendListView ? .fill : .none)
                        Text("トーク")
                    }
                }
                .tag(ViewSection.friendListView)
            
            MyPageView()
                .tabItem {
                    VStack {
                        Image(systemName: "person")
                            .environment(\.symbolVariants, selection == .myPageView ? .fill : .none)
                        Text("マイページ")
                    }
                }
                .tag(ViewSection.myPageView)
        }
    }
}

#Preview {
    HomeView()
}
