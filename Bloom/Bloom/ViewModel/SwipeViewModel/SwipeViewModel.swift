//
//  SwipeViewModel.swift
//  Bloom
//
//  Created by トム・クルーズ on 2024/03/02.
//

import Foundation
import FirebaseFirestore

class SwipeViewModel: ObservableObject {
    private var userDataModel = UserDataModel()
    
    @Published private(set) var friendProfiles: [ProfileElement] = []
    let db = Firestore.firestore()
    private let collectionName = "profiles"
    
    /// SignInUser取得メソッド
    func fetchSignInUser() async {
        DispatchQueue.main.async {
            self.friendProfiles.removeAll()
        }
        
        do {
            let querySnapshot = try await db.collection(collectionName).getDocuments()
            
            let profiles = querySnapshot.documents.compactMap { document -> ProfileElement? in
                let data = document.data()
                guard let userName = data["userName"] as? String,
                      let birth = data["birth"] as? String,
                      let genderString = data["gender"] as? String,
                      let gender = Gender(rawValue: genderString),
                      let address = data["address"] as? String,
                      let profileImages = data["profileImages"] as? [Data], // 仮定: Base64文字列の配列またはURLの配列
                      let homeImage = data["homeImage"] as? Data else { // 仮定: Base64文字列またはURL
                    print("error: fetchSignInUserでエラー")
                    return nil
                }
                
                return ProfileElement(
                    userName: userName,
                    birth: birth,
                    gender: gender,
                    address: address,
                    profileImages: profileImages,
                    homeImage: homeImage
                )
            }
            
            DispatchQueue.main.async {
                self.friendProfiles = profiles
            }
            
            print("SignInUser Profiles: \(String(describing: self.friendProfiles))")
        } catch {
            print("fetchSignInUsers error: \(error.localizedDescription)")
        }
    }
}
