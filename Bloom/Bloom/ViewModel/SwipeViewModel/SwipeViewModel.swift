import Foundation
import FirebaseFirestore

class SwipeViewModel: ObservableObject {
    private var userDataModel = UserDataModel()
    @Published private(set) var friendProfiles: [ProfileElement] = []
    let db = Firestore.firestore()
    private let collectionName = "profiles"
    private let fetchProfilesLimit: Int = 10
    
    init() {
        fetchSignInUser()
    }
    
    /// friendsをListtに追加
    func addFriendsToList(
        state: FriendEditState,
        friendProfile: ProfileElement
    ) {
        userDataModel.addFriendsToList(state: state, friendProfile: friendProfile) { error in
            if let error = error {
                print("error addFriendsToList: \(error.localizedDescription)")
            }
        }
    }
    
    /// SignInUser取得メソッド
    func fetchSignInUser() {
        friendProfiles.removeAll()
        
        userDataModel.fetchProfileUids(limit: fetchProfilesLimit) { uids, error in
            guard let uids = uids, error == nil else {
                print("Error fetching document IDs: \(error?.localizedDescription ?? "")")
                return
            }
            
            for uid in uids {
                print("uids: \(uid)")
                
                self.userDataModel.fetchProfile(uid: uid) { profile, error in
                    if let profile = profile {
                        print("proile: \(profile)")
                        self.friendProfiles.append(profile)
                    } else if let error = error {
                        print("Error fetching profiles: \(error.localizedDescription)")
                    } else {
                        print("fetchProfile error")
                    }
                }
            }
            
            if !self.friendProfiles.isEmpty {
                print("フェッチが終わったよ！！！！！！！！！！！！！！！！！")
                for profile in self.friendProfiles {
                    print("profile: \(profile)")
                }
            }
        }
    }
}
