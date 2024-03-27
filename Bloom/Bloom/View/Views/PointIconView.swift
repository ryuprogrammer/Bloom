//
//  PointIconView.swift
//  Bloom
//
//  Created by トム・クルーズ on 2024/03/27.
//

import SwiftUI

struct PointIconView: View {
    let point: Int
    var body: some View {
        Text("＋" + String(point))
            .font(.system(size: 15))
            .fontWeight(.bold)
            .foregroundStyle(Color.white)
            .frame(width: 35, height: 7)
            .padding(9)
            .background(Color.yellow)
            .clipShape(Capsule())
    }
}

#Preview {
    PointIconView(point: 10)
}
