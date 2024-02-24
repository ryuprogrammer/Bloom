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
    var body: some View {
        TabView(selection: $selection) {
            Text("Tab Content 1")
                .tabItem {
                    Image(systemName: "cloud.rainbow.half.fill")
                }
                .tag(1)
            
            Text("Tab Content 2")
                .tabItem {
                    Image(systemName: "lightbulb.max.fill")
                }
                .tag(2)
            
            Text("Tab Content 2")
                .tabItem {
                    Image(systemName: "message")
                }
                .tag(3)
                .badge(5)
            
            Text("Tab Content 2")
                .tabItem {
                    Image(systemName: "person.fill")
                }
                .tag(4)
        }
    }
}

#Preview {
    HomeView()
}
