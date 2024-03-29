//
//  MockData.swift
//  Bloom
//
//  Created by トム・クルーズ on 2024/03/29.
//

import Foundation
import SwiftUI

struct MockData {
    let prefectures = Prefectures()
    // ランダムな性別を生成する関数
    func randomGender() -> Gender {
        return Bool.random() ? .men : .wemen
    }

    // ランダムな趣味を生成する関数
    func randomHobbies() -> [String] {
        let hobbies = ["マジック", "ゲーム", "読書", "ダンス", "ドライブ", "カフェ巡り", "掃除"]
        let numberOfHobbies = Int.random(in: 1...3) // 1〜3個の趣味をランダムに選択
        var selectedHobbies = Set<String>()
        while selectedHobbies.count < numberOfHobbies {
            if let hobby = hobbies.randomElement() {
                selectedHobbies.insert(hobby)
            }
        }
        return Array(selectedHobbies)
    }

    // ランダムな住所を生成する関数
    func randomAddress() -> String {
        let addresses = prefectures.prefectures
        return addresses.randomElement() ?? "福井県🦀"
    }

    // ランダムな生年月日を生成する関数
    func randomBirth() -> String {
        let year = Int.random(in: 1990...2004)
        let month = Int.random(in: 10...12)
        let day = Int.random(in: 10...28) // とりあえず閏年は考慮しない
        return "\(year)\(month)\(day)"
    }

    // ランダムな場所を生成する関数
    func randomLocation() -> Location {
        let latitude = Double.random(in: -90...90)
        let longitude = Double.random(in: -180...180)
        return Location(longitude: longitude, latitude: latitude)
    }

    // プロジェクト内のアセットから指定の画像を取得してData型に変換する関数
    func imageDataFromAsset() -> Data? {
        guard let image = UIImage(named: "mockImage") else {
            fatalError("Failed to load image")
        }

        guard let imageData = image.jpegData(compressionQuality: 0.01) else {
            fatalError("Failed to convert image to JPEG data")
        }

        return imageData
    }

    // ランダムなホーム写真を生成する関数
    func randomHomeImageData() -> Data {
        // 仮のランダムな画像データを生成することを想定
        return Data()
    }

    // モックデータを生成する関数
    func generateMockData() -> [ProfileElement] {
        var mockData: [ProfileElement] = []
        for num in 0..<100 {
            let profile = ProfileElement(userName: "User_\(num))",
                                         introduction: "This is a sample introduction.",
                                         birth: randomBirth(),
                                         gender: randomGender(),
                                         address: randomAddress(),
                                         grade: Int.random(in: 1...100),
                                         hobby: randomHobbies(),
                                         location: randomLocation(),
                                         profession: "学生",
                                         profileImages: [imageDataFromAsset() ?? Data()],
                                         homeImage: imageDataFromAsset() ?? Data(),
                                         point: Int.random(in: 0...100))
            mockData.append(profile)
        }
        return mockData
    }
}
