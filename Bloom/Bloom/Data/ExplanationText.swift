//
//  ExplanationText.swift
//  Bloom
//
//  Created by トム・クルーズ on 2024/02/29.
//

import Foundation

struct ExplanationText {
    
    // MARK: - RegistrationView
    let nameEntryReason: String = "２〜10文字で入力してください。\nニックネームはあとから変更できます。"
    let nameEntryMaxError: String = "10文字以内のニックネームを入力してください。"
    let nameEntryMinError: String = "２文字以上のニックネームを入力してください。"
    let birthEntryDescription: String = "登録後は変更できません。"
    let birthEntryError: String = "生年月日の入力が正しくありません。"
    let photoEntryDescription: String = "写真を２枚以上追加してください。\n顔が写っているとマッチしやすいです。"
    let photoEntryError: String = "２枚以上追加してください。"
}
