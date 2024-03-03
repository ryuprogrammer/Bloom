//
//  SingleCardView.swift
//  Bloom
//
//  Created by トム・クルーズ on 2024/02/28.
//

import SwiftUI

struct SingleCardView: View {
    var card: CardModel
    @Binding var isLike: Bool?
    @State var imageNumber: Int = 0
    let minImageNumber = 1
    
    // 画面横幅取得→写真の横幅と縦幅に利用
    let imageWidth = UIScreen.main.bounds.width - 10
    let imageHeight = (UIScreen.main.bounds.height * 5) / 7
    
    var body: some View {
        ZStack {
            Color.blue
            
            DataImage(dataImage: card.profile.profileImages[imageNumber])
                .aspectRatio(contentMode: .fill)
                .frame(width: 360, height: 550)
            
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
                        Color.red.opacity(0.1)
                    }
                    
                    // 次の写真を表示
                    Button {
                        if imageNumber == card.profile.profileImages.count - 1 {
                            imageNumber = 0
                        } else {
                            imageNumber += 1
                        }
                    } label: {
                        Color.red.opacity(0.1)
                    }
                }
            }
            
            VStack {
                Spacer()
                
                HStack {
                    Text(card.profile.userName)
                    
                    Text(card.profile.address)
                        
                }
                .background(Color.white.opacity(0.5))
            }
        }
        .frame(width: 360, height: 550)
        .cornerRadius(15)
        .padding()
        .shadow(radius: 20)
    }
}

#Preview {
    struct PreviewView: View {
        @State var isLike: Bool? = nil
        @State var offset: CGFloat? = .zero
        var body: some View {
            SingleCardView(
                card: CardModel(
                    id: 1,
                    profile: ProfileElement(
                        userName: "もも",
                        birth: "",
                        gender: .men,
                        address: "栃木県",
                        profileImages: [Data(), Data(), Data()],
                        homeImage: Data()
                    )
                ),
                isLike: $isLike
            )
        }
    }
    
    return PreviewView()
}
