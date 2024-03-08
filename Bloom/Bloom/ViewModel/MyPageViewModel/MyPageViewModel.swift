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
    @Published var myProfile: ProfileElement? = nil
    
    /// プロフィール取得
    func fetchMyProfile() {
        let uid = userDataModel.fetchUid()
        
        userDataModel.fetchProfile(uid: uid, completion: { profile, error in
            if let profile = profile, error == nil {
                self.myProfile = profile
            }
        })
    }
    
    /// profile更新
    func upDateMyProfile(profile: ProfileElement) {
        print("更新するプロフィール: \(profile)")
        userDataModel.addProfile(profile: profile) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}
