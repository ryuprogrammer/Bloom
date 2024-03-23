//
//  ProfileElement.swift
//  Bloom
//
//  Created by トム・クルーズ on 2024/02/24.
//

import Foundation
import FirebaseFirestore
import SwiftData
import CoreLocation

struct ProfileElement: Codable, Equatable {
    @DocumentID var id: String?
    /// ユーザーネーム
    var userName: String
    /// 自己紹介文
    var introduction: String?
    /// 生年月日
    var birth: String
    /// 性別
    var gender: Gender
    /// 居住地
    var address: String
    /// グレード
    var grade: Int
    /// 趣味
    var hobby: [String]
    /// 現在地
    var location: Location?
    /// 職業
    var profession: String?
    /// プロフィール写真
    var profileImages: [Data]
    /// ホーム写真
    var homeImage: Data
}

// UserDefaults用にProfileElementのidを削除, swiftDataでも使用
struct MyProfileElement: Codable {
    var id: String
    /// ユーザーネーム
    var userName: String
    /// 自己紹介文
    var introduction: String?
    /// 生年月日
    var birth: String
    /// 性別
    var gender: Gender
    /// 居住地
    var address: String
    /// グレード
    var grade: Int
    /// 趣味
    var hobby: [String]
    /// 現在地
    var location: Location?
    /// 職業
    var profession: String?
    /// プロフィール写真
    var profileImages: [Data]
    /// ホーム写真
    var homeImage: Data
}

/// 位置情報
struct Location: Codable, Equatable {
    var longitude: Double
    var latitude: Double
}

/// 性別
enum Gender: String, Codable, CaseIterable {
    case men = "男性"
    case wemen = "女性"

    var id: String { rawValue }
}

/// profileのモックデータ
let mockProfileData = ProfileElement(
    userName: "もも",
    introduction: "自己紹介文自己紹介文自己紹介",
    birth: "20000421",
    gender: .men,
    address: "栃木県🍓",
    grade: 1,
    hobby: ["マジック", "おままごと"],
    location: nil,
    profession: "獣医師",
    profileImages: [Data(), Data(), Data(), Data()],
    homeImage: Data()
)

/// MyProfileのモックデータ
let mockMyProfileData = MyProfileElement(
    id: "",
    userName: "もも",
    introduction: "自己紹介文自己紹介文自己紹介",
    birth: "20000421",
    gender: .men,
    address: "栃木県🍓",
    grade: 1,
    hobby: ["マジック", "おままごと"],
    location: nil,
    profession: "獣医師",
    profileImages: [Data(), Data(), Data(), Data()],
    homeImage: Data())
