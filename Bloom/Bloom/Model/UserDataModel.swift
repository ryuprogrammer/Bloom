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
    func addProfile(
        userName: String,
        birth: String,
        gender: Gender,
        address: String,
        profileImages: [Data],
        homeImage: Data
    ) {
        // uid取得→これをdocmentidに使用
        let uid = fetchUid()
        
        do {
            let profile = ProfileElement(
                userName: userName,
                birth: birth,
                gender: gender,
                address: address,
                profileImages: profileImages,
                homeImage: homeImage
            )
            try db.collection(collectionName).document(uid).setData(from: profile)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    /// プロフィール取得メソッド
    func fetchProfile() async throws -> ProfileElement? {
        let uid = fetchUid()
        
        // UIDが空であるか確認
        guard !uid.isEmpty else {
            print("UID is empty")
            throw NSError(domain: "UserDataModel", code: 1, userInfo: [NSLocalizedDescriptionKey: "Document path cannot be empty."])
        }
        
        var profile: ProfileElement? = nil
        
        let docRef = db.collection(collectionName).document(uid)
        
        do {
            let docment = try await docRef.getDocument()
            print("document: \(docment)")
            if docment.exists {
                // profileData
                guard let profileData = docment.data() else { 
                    print("error: profileData")
                    return nil
                }
                
                // userName
                guard let userName = profileData["userName"] else {
                    print("error: userName")
                    return nil
                }
                guard let nameResult = userName as? String else {
                    print("error: nameResult")
                    return nil
                }
                
                // birth
                guard let birth = profileData["birth"] else {
                    print("error: birth")
                    return nil
                }
                guard let birthResult = birth as? String else {
                    print("error: birthResult")
                    print("birth: \(birth)")
                    return nil
                }
                
                print("birthResult: \(birthResult)")
                
                // gender
                guard let gender = profileData["gender"] else {
                    print("error: gender")
                    return nil
                }
                guard let genderResult = gender as? Gender else {
                    print("error: genderResult")
                    return nil
                }
                
                // address
                guard let address = profileData["address"] else { 
                    print("error: address")
                    return nil
                }
                        guard let addressResult = address as? String else { 
                            print("error: addressResult")
                            return nil
                        }
                
                // profileImages
                guard let profileImages = profileData["profileImages"] else { 
                    print("error: profileImages")
                    return nil
                }
                guard let profileImagesResult = profileImages as? [Data] else {
                    print("error: profileImagesResult")
                    return nil
                }
                
                // homeImage
                guard let homeImage = profileData["homeImage"] else {
                    print("error: homeImage")
                    return nil
                }
                guard let homeImageResult = homeImage as? Data else {
                    print("error: homeImageResult")
                    return nil
                }
                
                // データを入れる
                profile = ProfileElement(
                    userName: nameResult,
                    birth: birthResult,
                    gender: genderResult,
                    address: addressResult,
                    profileImages: profileImagesResult,
                    homeImage: homeImageResult
                )
                print("profile.userName: \(profile?.userName ?? "")")
                print("profile.profileImages: \(profile?.profileImages ?? [])")
            } else {
                print("Docment does not exist")
            }
        } catch {
            print("Error getting document: \(error)")
        }
        
        return profile
    }
}
