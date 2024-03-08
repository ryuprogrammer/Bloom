//
//  TalkView.swift
//  Bloom
//
//  Created by トム・クルーズ on 2024/02/24.
//

import SwiftUI

struct FriendListView: View {
    @ObservedObject var friendListViewModel = FriendListViewModel()
    @State var talkFriendProfiles: [ProfileElement] = []
    @State var matchFriendProfiles: [ProfileElement] = []
    
    let iconSize = UIScreen.main.bounds.width / 6
    
    var body: some View {
        NavigationStack {
            VStack {
                Section {
                    if !talkFriendProfiles.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(talkFriendProfiles, id: \.id) { profile in
                                    DataImage(dataImage: profile.homeImage)
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: iconSize, height: iconSize)
                                        .clipShape(Circle())
                                }
                            }
                            .padding()
                        }
                    } else {
                        Text("まだマッチした友達がいないよ。。")
                    }
                } header: {
                    HStack {
                        Text("マッチした友達")
                            .foregroundStyle(Color.gray)
                            .padding()
                        
                        Spacer()
                    }
                    .frame(height: 30)
                }
                
                Section {
                    ScrollView(.vertical, showsIndicators: false) {
                        ForEach(talkFriendProfiles, id: \.id) { profile in
                            NavigationLink(
                                destination: MessageView(
                                    chatPartnerProfile: profile
                                )
                                .toolbar(.hidden, for: .tabBar)
                            ) {
                                FriendListRowView(
                                    chatPartnerProfile: profile
                                )
                            }
                        }
                    }
                } header: {
                    HStack {
                        Text("トークしよう")
                            .foregroundStyle(Color.gray)
                            .padding()
                        
                        Spacer()
                    }
                    .frame(height: 30)
                }
                
                Spacer()
            }
            .navigationBarTitle("トーク", displayMode: .inline)
        }
        .accentColor(Color.white)
        .onChange(of: friendListViewModel.matchedFriendList.count) {
            talkFriendProfiles.removeAll()
            talkFriendProfiles.append(contentsOf: friendListViewModel.matchedFriendList)
        }
    }
}

#Preview {
    FriendListView()
}
