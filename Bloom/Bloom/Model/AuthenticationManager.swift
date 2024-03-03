import Foundation
import FirebaseAuth

class AuthenticationManager: ObservableObject {
    private var handle: AuthStateDidChangeListenerHandle?
    let userDataModel = UserDataModel()
    @Published var accountStatus: AccountStatus = .signOut
    
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
            accountStatus = .signOut
        } catch {
            print("Error")
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
                self.accountStatus = .signIn
                
                // profileが存在するか判定
                self.userDataModel.fetchProfileWithoutImages(uid: user.uid, completion: { profile, error in
                    if let _ = profile, error == nil {
                        // profileが存在する
                        self.accountStatus = .existProfile
                    } else if let error = error {
                        self.accountStatus = .signIn
                        print("Error fetching profiles: \(error.localizedDescription)")
                    }
                })
            } else {
                print("Sign-out")
                self.accountStatus = .signOut
            }
        }
    }
}