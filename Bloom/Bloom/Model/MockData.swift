//
//  MockData.swift
//  Bloom
//
//  Created by トム・クルーズ on 2024/02/24.
//

import Foundation

struct MockData {
    let explanation = ExplanationText()
    
    var profile = ProfileElement(
        userName: "もも",
        introduction: "",
        birth: "",
        gender: .men,
        address: "栃木県",
        profileImages: [],
        homeImage: Data()
    )
    
    init() {
        profile = ProfileElement(
            userName: "もも",
            introduction: explanation.testIntroduction,
            birth: "",
            gender: .men,
            address: "栃木県",
            profileImages: [],
            homeImage: Data()
        )
    }
}
