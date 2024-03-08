//
//  PhotoEntryView.swift
//  Bloom
//
//  Created by トム・クルーズ on 2024/03/02.
//

import SwiftUI
import PhotosUI

struct ProfileImageEditView: View {
    let explanationText = ExplanationText()
    @State var selectedItems: [PhotosPickerItem] = []
    @State var uiImages: [UIImage] = []
    @Binding var profileImages: [Data]
    @State var isPhotoValid: Bool = false
    let maxSelectionCount: Int = 6
    let minSelectionCount: Int = 2
    // 画面横幅取得→写真の横幅と縦幅に利用
    let imageWidth = UIScreen.main.bounds.width / 3 - 13
    let imageHeight = UIScreen.main.bounds.height / 5
    
    // 画面遷移用
    @Binding var path: [MyPagePath]
    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    
    var body: some View {
        ZStack {
            VStack {
                Text(explanationText.photoEntryDescription)
                    .font(.title3)
                    .padding()
                
                LazyVGrid(columns: columns) {
                    ForEach(0..<6) { number in
                        if number == uiImages.count { // 写真が0枚の時
                            PhotosPicker(
                                selection: $selectedItems,
                                maxSelectionCount: maxSelectionCount,
                                selectionBehavior: .ordered,
                                matching: .images
                            ) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Color.pink.opacity(0.5))
                                        .strokeBorder(Color.black, lineWidth: 2)
                                        .frame(width: imageWidth, height: imageHeight)
                                    
                                    Image(systemName: "plus")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                        .foregroundStyle(Color.white)
                                }
                            }
                        } else if uiImages.count > number { // 写真がある時
                            ZStack {
                                Image(uiImage: uiImages[number])
                                    .resizable()
                                    .frame(width: imageWidth, height: imageHeight)
                                    .aspectRatio(contentMode: .fit)
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                                
                                // 削除ボタン
                                Image(systemName: "minus.circle")
                                    .resizable()
                                    .frame(width: 26, height: 26)
                                    .foregroundStyle(Color.white)
                                    .background(Color.red)
                                    .clipShape(Circle())
                                    .offset(x: imageWidth/2-8, y: -imageHeight/2+5)
                                    .onTapGesture {
                                        selectedItems.remove(at: number)
                                    }
                            }
                        } else { // 写真がないフレーム
                            RoundedRectangle(cornerRadius: 20)
                                .strokeBorder(Color.black, lineWidth: 2)
                                .frame(width: imageWidth, height: imageHeight)
                        }
                    }
                }
                
                HStack {
                    Spacer()
                    
                    if uiImages.count == maxSelectionCount {
                        PhotosPicker(
                            selection: $selectedItems,
                            maxSelectionCount: maxSelectionCount,
                            selectionBehavior: .ordered,
                            matching: .images
                        ) {
                            HStack {
                                Image(systemName: "arrow.clockwise")
                                Text("写真を選び直す")
                            }
                        }
                        .padding()
                    }
                }
                
                if !isPhotoValid {
                    Text(explanationText.photoEntryError)
                        .foregroundStyle(Color.red)
                        .font(.title3)
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                
                Spacer()
            }
            .onChange(of: selectedItems) {
                Task {
                    uiImages.removeAll()
                    for item in selectedItems {
                        guard let data = try await item.loadTransferable(type: Data.self) else { continue }
                        guard let uiImage = UIImage(data: data) else { continue }
                        uiImages.append(uiImage)
                    }
                    
                    if uiImages.count >= minSelectionCount {
                        isPhotoValid = true
                    } else {
                        isPhotoValid = false
                    }
                }
            }
            
            VStack {
                Spacer()
                
                Button(action: {
                    for uiImage in uiImages {
                        if let imageData = uiImage.jpegData(compressionQuality: 0.1) {
                            profileImages.append(imageData)
                        }
                    }
                    path.removeAll()
                }, label: {
                    Text("プロフィール写真を更新")
                        .font(.title2)
                        .foregroundStyle(Color.white)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(isPhotoValid ? Color.pink.opacity(0.8) : Color(UIColor.lightGray))
                        .clipShape(Capsule())
                        .padding()
                })
                .disabled(!isPhotoValid)
            }
        }
        .onAppear {
            if uiImages.count >= minSelectionCount {
                isPhotoValid = true
            }
            for data in profileImages {
                if let uiImage = UIImage(data: data) {
                    uiImages.append(uiImage)
                }
            }
        }
    }
}

#Preview {
    struct PreviewView: View {
        @State var images: [Data] = []
        @State var path: [MyPagePath] = []
        var body: some View {
            ProfileImageEditView(profileImages: $images, path: $path)
        }
    }
    
    return PreviewView()
}
