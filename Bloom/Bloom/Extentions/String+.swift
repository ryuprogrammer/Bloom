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
    
    /// String型の数値をDate型に変換
    func toDate() -> Date? {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "ja_JP")
            dateFormatter.dateFormat = "yyyyMMdd"
            
            // 無効な日付の場合はnilを返す
            guard let birthday = dateFormatter.date(from: self) else {
                return nil
            }
            
            let calendar = Calendar(identifier: .gregorian)
            let today = Date()
            
            // 18歳未満のチェック
            if let date18YearsAgo = calendar.date(byAdding: .year, value: -18, to: today), birthday > date18YearsAgo {
                return nil
            }
            
            // 60歳以上のチェック
            if let date60YearsAgo = calendar.date(byAdding: .year, value: -60, to: today), birthday <= date60YearsAgo {
                return nil
            }
            
            return birthday
        }
}
