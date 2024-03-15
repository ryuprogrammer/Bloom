//
//  FriendPreviewView.swift
//  Bloom
//
//  Created by トム・クルーズ on 2024/03/09.
//

import SwiftUI

struct FriendPreviewView: View {
    @Environment(\.dismiss) var dismiss
    let profile: ProfileElement
    @State var imageNumber = 0
    @State var isShowImage: Bool = false
    let minImageNumber = 1
    
    let imageHeight = (UIScreen.main.bounds.height * 3) / 5
    let imageWidth = UIScreen.main.bounds.width
    let homeImageSize = UIScreen.main.bounds.width / 5
    let iconSize = UIScreen.main.bounds.width / 13
    
    var body: some View {
        ScrollView {
            VStack {
                // プロフィール写真
                    if !profile.profileImages.isEmpty {
                        ZStack {
                            DataImage(dataImage: profile.profileImages[imageNumber])
                                .aspectRatio(contentMode: .fit)
                                .frame(width: imageWidth, height: imageHeight)
                            
                            VStack {
                                Spacer()
                                // プロフィール写真の丸
                                HStack {
                                    ForEach(profile.profileImages.indices, id: \.self) { index in
                                        Circle()
                                            .fill(index == imageNumber ? Color.white : Color.white.opacity(0.4))
                                            .frame(width: 10, height: 10)
                                    }
                                }
                                .padding(10)
                            }
                            
                            // 次の写真のボタン
                            if profile.profileImages.count > minImageNumber {
                                HStack {
                                    // 前の写真を表示
                                    Button {
                                        if imageNumber == 0 {
                                            // 最後の写真を表示
                                            imageNumber = profile.profileImages.count - 1
                                        } else {
                                            // １つ前
                                            imageNumber -= 1
                                        }
                                    } label: {
                                        Color.clear
                                    }
                                    
                                    // 次の写真を表示
                                    Button {
                                        if imageNumber == profile.profileImages.count - 1 {
                                            imageNumber = 0
                                        } else {
                                            imageNumber += 1
                                        }
                                    } label: {
                                        Color.clear
                                    }
                                }
                            }
                        }
                    }
                
                HStack {
                    DataImage(dataImage: profile.homeImage)
                        .aspectRatio(contentMode: .fill)
                        .frame(width: homeImageSize, height: homeImageSize)
                        .clipShape(Circle())
                        .padding(.horizontal)
                    
                    VStack(alignment: .leading) {
                        Text(profile.userName)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text(profile.birth.toAge() + profile.address)
                            .font(.title)
                            .fontWeight(.bold)
                    }
                    
                    Spacer()
                }
                .padding(.vertical)
                
                Text(profile.introduction)
                    .fixedSize(horizontal: false, vertical: true)
                    .font(.title2)
                    .fontWeight(.bold)
            }
        }
    }
}

#Preview {
    struct PreviewView: View {
        var body: some View {
            FriendPreviewView(profile: ProfileElement(
                userName: "もも",
                introduction: "自己紹介文自己紹介文自己紹介",
                birth: "20000421",
                gender: .men,
                address: "栃木県🍓",
                profileImages: [Data(), Data(), Data(), Data()],
                homeImage: Data()
            ))
        }
    }
    
    return PreviewView()
}
