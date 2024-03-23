//
//  FaceDetectionView.swift
//  Bloom
//
//  Created by トム・クルーズ on 2024/03/20.
//

import SwiftUI

struct FaceDetectionView: View {
    let imageData: Data?
    let viewModel = FaceDetectionViewModel()
    @State var uiImage: UIImage?

    var body: some View {
        VStack {
            if let uiImage = self.uiImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
            }
        }
        .onAppear {
            guard let data = imageData else { return }
            viewModel.detectAndDrawFaces(imageData: data) { uiImage in
                self.uiImage = uiImage
            }
        }
    }
}
