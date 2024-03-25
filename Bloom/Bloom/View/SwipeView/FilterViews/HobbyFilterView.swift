//
//  HobbyFilterView.swift
//  Bloom
//
//  Created by トム・クルーズ on 2024/03/25.
//

import SwiftUI

struct HobbyFilterView: View {
    let filterViewModel = FilterViewModel()
    @Binding var hobbys: [String]
    @State var isHobbyValid: Bool = true
    let maxSelectNumber = 3
    let barHeight = UIScreen.main.bounds.height / 12

    @Environment(\.dismiss) private var dismiss

    let items = ["Apple", "Banana", "Orange", "Grapes", "Watermelon", "Pineapple", "Strawberry", "Blueberry", "Kiwi", "Mango", "Peach", "Pear", "Plum"]
        let maxWidth: CGFloat = UIScreen.main.bounds.width - 120 // マージンを取る

        var body: some View {
            VStack(alignment: .leading, spacing: 10) {
                ForEach(splitArrayByWidth(items, maxWidth: maxWidth), id: \.self) { row in
                    HStack(spacing: 10) {
                        ForEach(row, id: \.self) { item in
                            Text(item)
                                .padding(10)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .lineLimit(1)
                                .fixedSize()
                        }
                    }
                }
            }
            .padding()
        }

        func splitArrayByWidth(_ array: [String], maxWidth: CGFloat) -> [[String]] {
            var result: [[String]] = [[]]
            var currentRowWidth: CGFloat = 0

            for item in array {
                let itemWidth = item.getWidthOfString()
                if currentRowWidth + itemWidth > maxWidth {
                    currentRowWidth = 0
                    result.append([])
                }
                result[result.count - 1].append(item)
                currentRowWidth += itemWidth + 10 // スペースの幅を考慮
            }

            return result
        }

        func getWidthOfString(_ string: String) -> CGFloat {
            let font = UIFont.systemFont(ofSize: UIFont.systemFontSize) // デフォルトのフォントサイズを使用
            let attributes = [NSAttributedString.Key.font: font]
            let size = (string as NSString).size(withAttributes: attributes)
            return ceil(size.width) // 切り上げて返す
        }
}

#Preview {
    struct PreviewView: View {
        @State var hobbys: [String] = []
        var body: some View {
            HobbyFilterView(hobbys: $hobbys)
        }
    }

    return PreviewView()
}
