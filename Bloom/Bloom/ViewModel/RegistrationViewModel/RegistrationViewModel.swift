//
//  RegistrationViewModel.swift
//  Bloom
//
//  Created by トム・クルーズ on 2024/02/24.
//

import Foundation
import FirebaseFirestore

/// @Observableを使うことでプロパティ変数profileの変更によって自動でデータが更新
class RegistrationViewModel: ObservableObject {
    @Published private(set) var friendProfiles: [ProfileElement] = []
    private var lister: ListenerRegistration?
    private var userDataModel = UserDataModel()
    let explanationText = ExplanationText()
    let prefectures = Prefectures()
    
    // 初期化
    init() {
        lister = userDataModel.listenProfiles { [weak self] (profiles, error) in
            if let profiles = profiles {
                self?.friendProfiles.append(contentsOf: profiles)
                self?.friendProfiles.removeAll(where: { profile in
                    if let profileUid = profile.id {
                        let myUid = self?.userDataModel.fetchUid()
                        if profileUid == myUid {
                            return true
                        }
                    }
                    return false
                })
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    deinit {
        lister?.remove()
    }
    
    /// Profile追加メソッド
    func addProfile(
        userName: String,
        birth: String,
        gender: Gender,
        address: String,
        profileImages: [Data],
        homeImage: Data
    ) {
        userDataModel.addProfile(
            userName: userName,
            birth: birth,
            gender: gender,
            address: address,
            profileImages: profileImages,
            homeImage: homeImage
        )
    }
}
