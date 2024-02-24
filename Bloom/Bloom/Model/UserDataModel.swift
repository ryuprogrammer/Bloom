//
//  UserDataModel.swift
//  Bloom
//
//  Created by トム・クルーズ on 2024/02/24.
//

import Foundation
import FirebaseFirestore

class UserDataModel {
    /// コレクションの名称
    private let collectionName = "profiles"
    private var db = Firestore.firestore()
    
    /// リアルタイム監視
    func listenProfiles(completion: @escaping ([ProfileElement]?, Error?) -> Void) -> ListenerRegistration {
            let listener = db.collection(collectionName).addSnapshotListener { (querySnapshot, error) in
                if let error = error {
                    completion(nil, error)
                    return
                }
                
                var profiles: [ProfileElement] = []
                
                if let querySnapshot = querySnapshot {
                    for documentChange in querySnapshot.documentChanges {
                        if documentChange.type == .added {
                            do {
                                let profile = try documentChange.document.data(as: ProfileElement.self)
                                profiles.append(profile)
                            } catch {
                                completion(nil, error)
                            }
                        }
                    }
                }
                completion(profiles, nil)
            }
            return listener
        }
    
    /// Profile追加メソッド
    func addProfile(userName: String, age: Int, gender: Gender) {
        do {
            let profile = ProfileElement(userName: userName, age: age, gender: gender)
            try db.collection(collectionName).addDocument(from: profile) { error in
                if let error {
                    print(error.localizedDescription)
                    return
                }
                
                print("success")
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    /// データの取得
    func fetchProfile() {
        
    }
}
