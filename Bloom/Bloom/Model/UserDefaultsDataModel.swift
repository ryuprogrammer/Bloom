//
//  UserDefaultsDataModel.swift
//  Bloom
//
//  Created by トム・クルーズ on 2024/03/09.
//

import Foundation

struct UserDefaultsDataModel {
    let myProfileKey: String = "myProfileKey"
    
    /// MyProfileのデータの追加・更新
    func addMyProfile(myProfile: ProfileElement) {
        guard let id = myProfile.id else { return }
        let myProfileElement: MyProfileElement = MyProfileElement(
            id: id,
            userName: myProfile.userName,
            introduction: myProfile.introduction,
            birth: myProfile.birth,
            gender: myProfile.gender,
            address: myProfile.address,
            profileImages: myProfile.profileImages,
            homeImage: myProfile.homeImage
        )
        
        let jsonEncoder = JSONEncoder()
        jsonEncoder.keyEncodingStrategy = .convertToSnakeCase
        guard let profileStrData = try? jsonEncoder.encode(myProfileElement) else {
            return
        }
        
        UserDefaults.standard.set(profileStrData, forKey: myProfileKey)
    }
    
    /// MyProfileのデータの取得
    func fetchMyProfile() -> MyProfileElement? {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let data = UserDefaults.standard.data(forKey: myProfileKey),
              let profile = try? jsonDecoder.decode(MyProfileElement.self, from: data) else {
            return nil
        }
        
        return profile
    }
    
    /// MyProfileのデータの削除
    func deleteMyProfile() {
        UserDefaults.standard.removeObject(forKey: myProfileKey)
    }
}
