//
//  ProfileElement+.swift
//  Bloom
//
//  Created by トム・クルーズ on 2024/03/13.
//

import Foundation

extension ProfileElement {
    /// ProfileElementにキャスト
    func toMyProfileElement() -> MyProfileElement {
        let profile = MyProfileElement(
            id: self.id ?? "",
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
