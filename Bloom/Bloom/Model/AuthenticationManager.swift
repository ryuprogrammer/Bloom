import Foundation
import GoogleSignIn
import FirebaseCore
import FirebaseAuth

class AuthenticationManager: ObservableObject {
    private var handle: AuthStateDidChangeListenerHandle?
    let userDataModel = UserDataModel()
    let userDefaultsDataModel = UserDefaultsDataModel()
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
        let user = Auth.auth().currentUser
        
        if let user {
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
        if let _ = userDefaultsDataModel.fetchMyProfile() {
            print("userDefaultsにデータある！！！！！！！")
            // プロフィールある
            self.accountStatus = .valid
        } else { // userDefaultsにはプロフィールない
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
                            print("アカウントは存在！！！！！！！")
                            // アカウントが正常に存在する
                            self.accountStatus = .valid
                            // userDefaultsにもアカウントを追加
                            self.addProfileToDevice()
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
    
    // firebaseのプロフィールをuserDefaultsに追加
    func addProfileToDevice() {
        let uid = userDataModel.fetchUid()
        
        /// uidを指定して、プロフィールを1つ取得 （画像データまで取得）
        userDataModel.fetchProfile(uid: uid) { profile, error in
            if let profile = profile, error == nil {
                // userDefaultsにprofile追加
                self.userDefaultsDataModel.addMyProfile(myProfile: profile)
            } else if let error = error {
                print("error: addProfileToDevice()")
                print(error.localizedDescription)
            }
        }
    }
}
