//
//  MyProfileElement+.swift
//  Bloom
//
//  Created by トム・クルーズ on 2024/03/11.
//

import Foundation

extension MyProfileElement {
    /// ProfileElementにキャスト
    func toProfileElement() -> ProfileElement {
        let profile = ProfileElement(
            id: self.id,
            userName: self.userName,
            introduction: self.introduction,
            birth: self.birth,
            gender: self.gender,
            address: self.address,
            profileImages: self.profileImages,
            homeImage: self.homeImage
        )
        
        return profile
    }
}
