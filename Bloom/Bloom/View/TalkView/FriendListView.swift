//
//  TalkView.swift
//  Bloom
//
//  Created by トム・クルーズ on 2024/02/24.
//

import SwiftUI
import SwiftData

struct FriendListView: View {
    @Environment(\.modelContext) private var context
    @Query private var talkFriendElement: [TalkFriendElement]
    
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
        .onAppear {
            // 最初はSwiftDataのデータを描画
            if talkFriendProfiles.isEmpty && !talkFriendElement.isEmpty {
                print("最初に描画する条件に合致")
                for friend in talkFriendElement {
                    let profile = ProfileElement(
                        id: friend.profile.id,
                        userName: friend.profile.userName,
                        introduction: friend.profile.introduction,
                        birth: friend.profile.birth,
                        gender: friend.profile.gender,
                        address: friend.profile.address,
                        profileImages: friend.profile.profileImages,
                        homeImage: friend.profile.homeImage
                    )
                    talkFriendProfiles.append(profile)
                }
            }
        }
    }
}

#Preview {
    FriendListView()
}
