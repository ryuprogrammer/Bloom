//
//  AdvertisementView.swift
//  Bloom
//
//  Created by トム・クルーズ on 2024/03/26.
//

import SwiftUI

struct AdvertisementView: View {
    var body: some View {
        Text("マッチを加速させよう")
            .font(.largeTitle)
            .fontWeight(.bold)
            .frame(maxWidth: .infinity)
            .frame(height: 80)
            .background(Color.cyan.opacity(0.5))
    }
}

#Preview {
    AdvertisementView()
}
