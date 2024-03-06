import Foundation
import FirebaseAuth

class AuthenticationManager: ObservableObject {
    private var handle: AuthStateDidChangeListenerHandle?
    let userDataModel = UserDataModel()
    @Published var accountStatus: AccountStatus = .none
    
    init() {
        checkAccountStatus()
    }
    
    deinit {
        // ここで認証状態の変化の監視を解除する
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            accountStatus = .none
        } catch {
            print("Error")
        }
    }
    
    func deleteUser() {
        if let user = Auth.auth().currentUser {
            user.delete { error in
                if let error = error {
                    print("error: \(error.localizedDescription)")
                } else {
                    print("Account deleted")
                    self.accountStatus = .none
                }
            }
        }
    }
    
    func checkAccountStatus() {
        // 既存のリスナーがあれば削除
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
        
        // ここで認証状態の変化を監視する（リスナー）
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            print("auth: \(auth)")
            
            if let user = user {
                print("Sign-in")
                print("user: \(user.uid)")
                self.accountStatus = .existsNoProfile
                
                // profileが存在するか判定
                self.userDataModel.fetchProfileWithoutImages(uid: user.uid, completion: { profile, error in
                    if let _ = profile, error == nil {
                        // アカウントが正常に存在する
                        self.accountStatus = .valid
                    } else if let error = error {
                        self.accountStatus = .existsNoProfile
                        print("Error fetching profiles: \(error.localizedDescription)")
                    }
                })
            } else {
                print("Sign-out")
                self.accountStatus = .none
            }
        }
    }
}
