//
//  MyPageViewModel.swift
//  Bloom
//
//  Created by トム・クルーズ on 2024/03/08.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class MyPageViewModel: ObservableObject {
    let userDataModel = UserDataModel()
    let userDefaultsDataModel = UserDefaultsDataModel()
    @Published var myProfile: ProfileElement? = nil
    
    /// プロフィール取得：UserDefaults
    func fetchMyProfile() {
        if let profile = userDefaultsDataModel.fetchMyProfile() {
            myProfile = ProfileElement(
                userName: profile.userName,
                introduction: profile.introduction,
                birth: profile.birth,
                gender: profile.gender,
                address: profile.address,
                profileImages: profile.profileImages,
                homeImage: profile.homeImage
            )
        } else {
            print("error: fetchMyProfile")
        }
    }
    
    /// profile更新：UserDefaultsとfirestrage
    func upDateMyProfile(profile: ProfileElement) {
        userDataModel.addProfile(profile: profile) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
        
        userDefaultsDataModel.addMyProfile(myProfile: profile)
    }
}
