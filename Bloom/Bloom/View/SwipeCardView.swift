//
//  SingleCardView.swift
//  Bloom
//
//  Created by トム・クルーズ on 2024/02/28.
//

import SwiftUI

struct SwipeCardView: View {
    var card: CardModel
    @State var imageNumber: Int = 0
    @State var isShowProfile: Bool = true
    let minImageNumber = 1
    
    // 画面横幅取得→写真の横幅と縦幅に利用
    let imageWidth = UIScreen.main.bounds.width - 35
    let imageHeight = (UIScreen.main.bounds.height * 5) / 8
    
    var body: some View {
        ZStack {
            Color.blue
            
            if !card.profile.profileImages.isEmpty {
//                DataImage(dataImage: card.profile.profileImages[imageNumber])
//                    .aspectRatio(contentMode: .fill)
//                    .frame(width: imageWidth, height: imageHeight)

                if let data = card.profile.profileImages.first {
                    FaceDetectionView(imageData: data)
                        .aspectRatio(contentMode: .fill)
                        .frame(width: imageWidth, height: imageHeight)
                }
            }
            
            if card.profile.profileImages.count > minImageNumber {
                HStack {
                    // 前の写真を表示
                    Button {
                        if imageNumber == 0 {
                            // 最後の写真を表示
                            imageNumber = card.profile.profileImages.count - 1
                        } else {
                            // １つ前
                            imageNumber -= 1
                        }
                    } label: {
                        Color.red.opacity(0)
                    }
                    
                    // 次の写真を表示
                    Button {
                        if imageNumber == card.profile.profileImages.count - 1 {
                            imageNumber = 0
                        } else {
                            imageNumber += 1
                        }
                    } label: {
                        Color.white.opacity(0)
                    }
                }
            }
            
            // カード上の文字情報
            VStack {
                if card.profile.profileImages.count > minImageNumber {
                    HStack {
                        ForEach(card.profile.profileImages.indices, id: \.self) { index in
                            Circle()
                                .fill(index == imageNumber ? Color.white : Color.white.opacity(0.4))
                                .frame(width: 10, height: 10)
                        }
                    }
                    .padding(10)
                }
                
                Spacer()
                
                // プロフィール情報
                VStack {
                    HStack(alignment: .bottom) {
                        VStack(alignment: .leading) {
                            Text(card.profile.userName)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundStyle(Color.black)
                            
                            Text(card.profile.birth.toAge() + card.profile.address)
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundStyle(Color.black)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            withAnimation {
                                isShowProfile.toggle()
                            }
                        }, label: {
                            Image(systemName: isShowProfile ? "arrowshape.down.circle.fill":"arrowshape.up.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40, height: 40)
                                .foregroundStyle(Color.pink.opacity(0.8))
                        })
                    }
                    .padding(5)
                    
                    if isShowProfile {
                        Text("プロフィール文章がないよ！プロフィール文章プロフィール文章プロフィール文章プロフィール文章プロフィール文章プロフィール文章プロフィール文章プロフィール文章文章プロフィール文章プロフィール文章プロフィール文章プロフィール文章プロフィール文章プロフィール文章文章プロフィール文章プロフィール文章プロフィール文章プロフィール文章プロフィール文章プロフィール文章")
                            .fixedSize(horizontal: false, vertical: true)
                            .fontWeight(.bold)
                            .foregroundStyle(Color.black)
                    }
                }
                .padding()
                .frame(width: imageWidth)
                .background(Color.white)
                .shadow(radius: 20)
            }
            
            if let isLike = card.isLike {
                if isLike {
                    ZStack {
                        Color.pink.opacity(0.5)
                        
                        Image(systemName: "hand.thumbsup")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 150, height: 150)
                            .foregroundStyle(Color.white)
                            .offset(x: -60, y: -130)
                    }
                } else {
                    ZStack {
                        Color.black.opacity(0.5)
                        
                        Image(systemName: "heart.slash")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 150, height: 150)
                            .foregroundStyle(Color.white)
                            .offset(x: 60, y: -130)
                    }
                }
            }
        }
        .frame(width: imageWidth, height: imageHeight)
        .cornerRadius(25)
        .padding()
        .shadow(radius: 20)
    }
}

#Preview {
    struct PreviewView: View {
        @State var isLike: Bool? = nil
        @State var offset: CGFloat? = .zero
        var body: some View {
            SwipeCardView(
                card: CardModel(
                    id: 1,
                    profile: ProfileElement(
                        userName: "もも",
                        introduction: "プロフィール文章プロフィール文章プロフィール文章プロフィール文章プロフィール文章プロフィール文章プロフィール文章プロフィール文章文章プロフィール文章プロフィール文章プロフィール文章プロフィール文章プロフィール文章プロフィール文章文章プロフィール文章プロフィール文章プロフィール文章プロフィール文章プロフィール文章プロフィール文章",
                        birth: "",
                        gender: .men,
                        address: "栃木県🍓",
                        profileImages: [Data(), Data(), Data(), Data()],
                        homeImage: Data()
                    )
                )
            )
        }
    }
    
    return PreviewView()
}
