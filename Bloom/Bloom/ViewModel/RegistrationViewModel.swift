//
//  RegistrationViewModel.swift
//  Bloom
//
//  Created by トム・クルーズ on 2024/02/24.
//

import Foundation
import FirebaseFirestore

/// @Observableを使うことでプロパティ変数profileの変更によって自動でデータが更新
@Observable class RegistrationViewModel {
    private(set) var profiles: [ProfileElement] = []
    private var lister: ListenerRegistration?
    /// コレクションの名称
    private let collectionName = "profiles"
    
    // 初期化
    init() {
        let db = Firestore.firestore()
        
        lister = db.collection(collectionName).addSnapshotListener { (querySnapshot, error) in
            
            if let error {
                print(error.localizedDescription)
                return
            }
            if let querySnapshot {
                for documentChange in querySnapshot.documentChanges {
                    if documentChange.type == .added {
                        do {
                            // Codableを使って構造体に変換する
                            let profile = try documentChange.document.data(as: ProfileElement.self)
                            self.profiles.append(profile)
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
            }
        }
    }
    
    deinit {
        lister?.remove()
    }
    
    /// Profile追加メソッド
    func addProfile(userName: String, age: Int, gender: Gender) {
        do {
            let profile = ProfileElement(userName: userName, age: age, gender: gender)
            let db = Firestore.firestore()
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
}
