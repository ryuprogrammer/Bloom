//
//  UserDataModel.swift
//  Bloom
//
//  Created by トム・クルーズ on 2024/02/24.
//

import Foundation
import FirebaseAuth
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
    
    /// uid取得メソッド
    func fetchUid() -> String {
        var uid: String = ""
        let user = Auth.auth().currentUser
        
        if let user {
            uid = user.uid
        }
        
        return uid
    }
    
    /// Profile追加メソッド
    func addProfile(userName: String, age: Int, gender: Gender) {
        // uid取得→これをdocmentidに使用
        let uid = fetchUid()
        
        do {
            let profile = ProfileElement(userName: userName, age: age, gender: gender)
            try db.collection(collectionName).document(uid).setData(from: profile)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    func fetchProfile() async throws -> ProfileElement? {
        let uid = fetchUid()
        var profile: ProfileElement? = nil
        
        let docRef = db.collection(collectionName).document(uid)
        
        do {
            let docment = try await docRef.getDocument()
            print("document: \(docment)")
            if docment.exists {
                if let profileData = docment.data(),
                   let userName = profileData["userName"],
                   let age = profileData["age"],
                   let gender = profileData["gender"],
                   let StringGender = gender as? String,
                   let newGender = Gender(rawValue: StringGender),
                   let StringUserName = userName as? String,
                   let IntAge = age as? Int {
                    profile = ProfileElement(
                        userName: StringUserName,
                        age: IntAge,
                        gender: newGender
                    )
                }
            } else {
                print("Docment does not exist")
            }
        } catch {
            print("Error getting document: \(error)")
        }
        
        return profile
    }
}
