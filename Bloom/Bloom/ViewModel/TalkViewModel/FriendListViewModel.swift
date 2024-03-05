//
//  FriendListViewModel.swift
//  Bloom
//
//  Created by トム・クルーズ on 2024/02/27.
//

import Foundation
import FirebaseFirestore

class FriendListViewModel: ObservableObject {
    let chatDataModel = ChatDataModel()
    let userDataModel = UserDataModel()
    @Published var newMessageCount: Int = 3
    @Published var matchedFriendList: [ProfileElement] = []
    private var listener: ListenerRegistration?
    let db = Firestore.firestore()
    /// コレクションの名称
    private let collectionName = "chatRoom"
    let mostLongStringNumber: Int = 16
    
    init() {
        fetchMatchedFriendList()
    }
    
    deinit {
        listener?.remove()
    }
    
    /// マッチした友達を取得
    func fetchMatchedFriendList() {
        matchedFriendList.removeAll()
        
        // マッチした友達のUidを取得
        userDataModel.fetchProfileWithFriendStatus(friendStatus: .likeByMe) { matchedFriendUids, error in
            guard let uids = matchedFriendUids, error == nil else {
                print("Error fetching matchedFriendUids: \(error?.localizedDescription ?? "")")
                return
            }
            
            // マッチした友達の数だけプロフィール取得
            for uid in uids {
                print("マッチした友達のUid: \(uid)")
                self.userDataModel.fetchProfile(uid: uid) { profile, error in
                    guard let profile = profile else { return }
                    self.matchedFriendList.append(profile)
                    print("マッチした友達の名前: \(profile.userName)")
                }
            }
        }
        
        print("matchedFriendList.count: \(matchedFriendList.count)")
    }
    
    /// 全ての未読メッセージ数の取得
    func fetchNewMessageCountAll(chatPartnerProfile: ProfileElement) async {
        guard let roomID = fetchRoomID(chatPartnerProfile: chatPartnerProfile) else { return }

        do {
            // `messages`サブコレクションからメッセージを取得
            let querySnapshot = try await db.collection(collectionName).document(roomID).collection("messages").getDocuments()

            // UIの更新はメインスレッドで行う
            DispatchQueue.main.async {
                self.newMessageCount = 0
                
                let messages = querySnapshot.documents.compactMap { document in
                    try? document.data(as: MessageElement.self)
                }
                
                self.newMessageCount = messages.filter { message in
                    message.isNewMessage == true && message.name == chatPartnerProfile.userName
                }.count

                print("相手（全）\(chatPartnerProfile.userName)")
                print("newMessageCount（全）: \(self.newMessageCount)")
            }
        } catch {
            print("fetchMessages error: \(error.localizedDescription)")
        }
    }
    
    /// Listに表示する文字の長さを調整
    func adjustStringLengths(message: String) -> String {
        var adjustMessage: String = ""
        if message.count >= mostLongStringNumber {
            adjustMessage = message.suffix(mostLongStringNumber) + "..."
        } else {
            adjustMessage = message
        }
        
        return adjustMessage
    }
    
    /// roomID取得メソッド
    func fetchRoomID(chatPartnerProfile: ProfileElement) -> String? {
        return chatDataModel.fetchRoomID(chatPartnerProfile: chatPartnerProfile)
    }
}
