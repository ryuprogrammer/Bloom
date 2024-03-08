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
    let homeImageEntryDescription: String = "ホーム写真を追加してください。\nトークのアイコンなどに使用します。"
    
    // MARK: - TestData
    let testIntroduction: String = "プロフィールを見ていただいてありがとうございます！\n週末は家で演奏会を開いています！よかったら見に来てください！"
    
    // MARK: - MyPageEditView
    let introductionEditDescription: String = "自己紹介文を120字以内で入力してください。"
    let introductionEditError: String = "120文字以内で入力してください。"
}
