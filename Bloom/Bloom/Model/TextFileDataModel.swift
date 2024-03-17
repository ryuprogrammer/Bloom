//
//  TextFileDataModel.swift
//  Bloom
//
//  Created by トム・クルーズ on 2024/03/17.
//

import Foundation

struct TextFileDataModel {
    /// 長文読み込み
    func readFile(fileCase: FileCase) async -> String {
        guard let fileURL = Bundle.main.url(forResource: fileCase.rawValue, withExtension: "txt"),
              let fileContents = try? String(contentsOf: fileURL, encoding: .utf8) else {
            fatalError("ファイルの読み込みができません")
        }

        return fileContents
    }
}

enum FileCase: String {
    case service = "serviceDescription"
    case privacy = "privacyDescription"
    case delete = "deleteDescription"
}
