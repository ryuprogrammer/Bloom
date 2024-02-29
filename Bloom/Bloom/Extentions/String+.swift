//
//  String+.swift
//  Bloom
//
//  Created by トム・クルーズ on 2024/03/01.
//

import Foundation

extension String {
    /// n文字目の文字を取得
    func forthText(forthNumber: Int) -> String? {
        if self.count >= forthNumber {
            let index = self.index(self.startIndex, offsetBy: forthNumber-1)
            let resultText = String(self[index])
            return resultText
        } else {
            return nil
        }
    }
}
