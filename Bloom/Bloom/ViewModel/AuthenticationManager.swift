//
//  AuthenticationManager.swift
//  Bloom
//
//  Created by トム・クルーズ on 2024/02/21.
//

import Foundation
import FirebaseAuth

@Observable class AuthenticationManager {
    private var handle: AuthStateDidChangeListenerHandle!
    let userDataModel = UserDataModel()
    var accountStatus: AccountStatus = .signOut
    
    deinit {
        // ここで認証状態の変化の監視を解除する
        Auth.auth().removeStateDidChangeListener(handle)
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            accountStatus = .signOut
        } catch {
            print("Error")
        }
    }
    
    func checkAccountStatus() async {
        // ここで認証状態の変化を監視する（リスナー）
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if let _ = user {
                print("Sign-in")
                self.accountStatus = .signIn
            } else {
                print("Sign-out")
                self.accountStatus = .signOut
            }
        }
        
        // profileが存在するか判定
        do {
            if let profile = try await userDataModel.fetchProfile() {
                accountStatus = .existProfile
            }
        } catch {
            print("プロフィール取得失敗")
        }
    }
}
