//
//  ProfileElement.swift
//  Bloom
//
//  Created by トム・クルーズ on 2024/02/24.
//

import Foundation
import FirebaseFirestore

struct ProfileElement: Codable, Equatable {
    @DocumentID var id: String?
    var userName: String
    var introduction: String
    var birth: String
    var gender: Gender
    var address: String
    var profileImages: [Data]
    var homeImage: Data
}

enum Gender: String, Codable, CaseIterable {
    case men = "男性"
    case wemen = "女性"
    
    var id: String { rawValue }
}
