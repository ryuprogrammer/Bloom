//
//  SingleCardView.swift
//  Bloom
//
//  Created by トム・クルーズ on 2024/02/28.
//

import SwiftUI

struct SingleCardView: View {
    @State private var translation: CGSize = .zero
        var body: some View {
            GeometryReader { (proxy: GeometryProxy) in
                Text("Number 0")
                    .font(.title)
                    .frame(width: proxy.size.width - 16 * 2, height: proxy.size.height - 16 * 3, alignment: .center)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .offset(CGSize(width: self.translation.width, height: 0))
                    .rotationEffect(.degrees(Double(self.translation.width / 300) * 25), anchor: .bottom)
                    .gesture(
                        DragGesture()
                            .onChanged({ self.translation = $0.translation })
                            .onEnded({ _ in self.translation = CGSize(width: 600, height: 0) })
                )
            }
        }
}

#Preview {
    SingleCardView()
}
