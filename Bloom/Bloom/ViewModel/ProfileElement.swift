//
//  ProfileElement.swift
//  Bloom
//
//  Created by トム・クルーズ on 2024/02/24.
//

import Foundation
import FirebaseFirestore

struct ProfileElement: Codable {
    @DocumentID var id: String?
    var userName: String
    var age: Int
    var gender: Gender
}

enum Gender: String, Codable {
    case men = "男性"
    case wemen = "女性"
}
