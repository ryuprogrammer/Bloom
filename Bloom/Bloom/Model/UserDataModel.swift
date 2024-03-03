//
//  UserDataModel.swift
//  Bloom
//
//  Created by トム・クルーズ on 2024/02/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class UserDataModel {
    /// コレクションの名称
    private let collectionName = "profiles"
    let friendCollectionName = "friends"
    let friendListCollectionName = "friendList"
    private var db = Firestore.firestore()
    private let storage = Storage.storage()
    
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
    
    /// friends追加メソッド
    func addFriendsToList(
        state: FriendEditState,
        friendProfile: ProfileElement,
        completion: @escaping (Error?) -> Void
    ) {
        // UIDを取得
        let uid = fetchUid()
        // 自分のRef
        let myDocumentRef = db.collection(friendCollectionName).document(uid).collection(friendListCollectionName).document()
        
        guard let friendUid = friendProfile.id else { return }
        // 相手のRef
        let friendDocmentRef = db.collection(friendCollectionName).document(friendUid).collection(friendListCollectionName).document()
        
        // 相手のデータ
        let friendUidAndState: FriendsElement = FriendsElement(
            friedUid: friendUid,
            status: state
        )
        
        // Firestoreに保存するために、Codableオブジェクトを辞書に変換
        do {
            try myDocumentRef.setData(from: friendUidAndState) { error in
                if let error = error {
                    // エラー処理
                    completion(error)
                } else {
                    // 成功した場合、nilをコールバックに渡す
                    completion(nil)
                }
            }
        } catch let error {
            completion(error)
        }
        
        if state != .unLikeByMe { // この時だけ相手のRefにはデータを追加しない.
            // Firestoreに保存するために、Codableオブジェクトを辞書に変換
            do {
                try friendDocmentRef.setData(from: friendUidAndState) { error in
                    if let error = error {
                        // エラー処理
                        completion(error)
                    } else {
                        // 成功した場合、nilをコールバックに渡す
                        completion(nil)
                    }
                }
            } catch let error {
                completion(error)
            }
        }
    }
    
    /// Profile追加メソッド（更新も可能）
    func addProfile(profile: ProfileElement, completion: @escaping (Error?) -> Void) {
        // UIDを取得
        let uid = fetchUid()
        
        // Firestoreに保存するデータを辞書形式で用意
        let firestoreData: [String: Any] = [
            "userName": profile.userName,
            "birth": profile.birth,
            "gender": profile.gender.rawValue,
            "address": profile.address
        ]
        
        // 指定したUIDを持つドキュメントにデータを追加（または更新）
        db.collection(collectionName).document(uid).setData(firestoreData) { error in
            guard error == nil else {
                completion(error)
                return
            }
            
            // Firebase Storageにプロファイル画像をアップロード
            let storageRef = self.storage.reference()
            
            // profileImagesのアップロード
            for (index, imageData) in profile.profileImages.enumerated() {
                let imageRef = storageRef.child("profileImages/\(uid)/image\(index).jpg")
                imageRef.putData(imageData, metadata: nil) { metadata, error in
                    guard error == nil else {
                        completion(error)
                        return
                    }
                }
            }
            
            // homeImageのアップロード
            let homeImageRef = storageRef.child("homeImages/\(uid)/home.jpg")
            homeImageRef.putData(profile.homeImage, metadata: nil) { metadata, error in
                guard error == nil else {
                    completion(error)
                    return
                }
            }
    
            // すべてのアップロードが完了したことをコールバック
            completion(nil)
        }
    }
    
    /// SignInUserのuidを数を指定して取得
    func fetchProfileUids(limit: Int, completion: @escaping ([String]?, Error?) -> Void) {
        let db = Firestore.firestore()
        
        db.collection("profiles").limit(to: limit).getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            
            let documentIDs = querySnapshot?.documents.map { $0.documentID }
            completion(documentIDs, nil)
        }
    }
    
    /// uidを指定して、プロフィールを１つ取得 （画像データは含まない）
    func fetchProfileWithoutImages(uid: String, completion: @escaping (ProfileElement?, Error?) -> Void) {
        let db = Firestore.firestore()
        
        db.collection("profiles").document(uid).getDocument { document, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let document = document, document.exists, let data = document.data() else {
                completion(nil, NSError(domain: "ProfileError", code: 404, userInfo: [NSLocalizedDescriptionKey: "Profile not found."]))
                return
            }
            
            guard let userName = data["userName"] as? String,
                  let birth = data["birth"] as? String,
                  let genderRaw = data["gender"] as? String,
                  let gender = Gender(rawValue: genderRaw),
                  let address = data["address"] as? String else {
                completion(nil, NSError(domain: "DataError", code: 100, userInfo: [NSLocalizedDescriptionKey: "Data format error."]))
                return
            }
            
            // 画像データは含まれません
            let profile = ProfileElement(userName: userName, birth: birth, gender: gender, address: address, profileImages: [], homeImage: Data())
            completion(profile, nil)
        }
    }
    
    /// uidを指定して、プロフィールを1つ取得 （画像データまで取得）
    func fetchProfile(uid: String, completion: @escaping (ProfileElement?, Error?) -> Void) {
        db.collection("profiles").document(uid).getDocument { document, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let document = document, document.exists, let data = document.data() else {
                completion(nil, NSError(domain: "ProfileError", code: 404, userInfo: [NSLocalizedDescriptionKey: "Profile not found."]))
                return
            }
            
            guard let userName = data["userName"] as? String,
                  let birth = data["birth"] as? String,
                  let genderRaw = data["gender"] as? String,
                  let gender = Gender(rawValue: genderRaw),
                  let address = data["address"] as? String else {
                completion(nil, NSError(domain: "DataError", code: 100, userInfo: [NSLocalizedDescriptionKey: "Data format error."]))
                return
            }
            
            // プロファイル画像とホーム画像のパスを準備
            let storageRef = self.storage.reference()
            let profileImagesRef = storageRef.child("profileImages/\(uid)")
            let homeImageRef = storageRef.child("homeImages/\(uid)/home.jpg")
            
            // ホーム画像をダウンロード
            homeImageRef.getData(maxSize: 10 * 1024 * 1024) { homeImageData, error in
                guard let homeImageData = homeImageData, error == nil else {
                    completion(nil, error)
                    return
                }
                
                // プロファイル画像のダウンロード
                // 注意: この実装では、プロファイル画像の具体的な名前や数を事前には知りません
                profileImagesRef.listAll { (result, error) in
                    if let error = error {
                        completion(nil, error)
                        return
                    }
                    
                    let group = DispatchGroup()
                    var profileImagesData = [Data]()
                    
                    guard let result = result else { return }
                    
                    for item in result.items {
                        group.enter()
                        item.getData(maxSize: 10 * 1024 * 1024) { data, error in
                            defer { group.leave() }
                            
                            if let data = data, error == nil {
                                profileImagesData.append(data)
                            }
                        }
                    }
                    
                    group.notify(queue: .main) {
                        // すべてのプロファイル画像がダウンロードされた後に実行
                        let profile = ProfileElement(id: uid, userName: userName, birth: birth, gender: gender, address: address, profileImages: profileImagesData, homeImage: homeImageData)
                        completion(profile, nil)
                    }
                }
            }
        }
    }

}
