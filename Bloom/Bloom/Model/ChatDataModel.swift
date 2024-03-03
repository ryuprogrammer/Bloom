//
//  ChatDataModel.swift
//  Bloom
//
//  Created by トム・クルーズ on 2024/02/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class ChatDataModel: ObservableObject {
    var userDataModel = UserDataModel()
    private var db = Firestore.firestore()
    let countCollectionName = "newMessageCount"
    /// チャットを追加
    func addMessage(chatPartnerProfile: ProfileElement, message: String) {
        // 自分のUid取得
        var uid: String = ""
        
        let user = Auth.auth().currentUser
        
        if let user {
            uid = user.uid
        }
        
        guard let roomID = fetchRoomID(chatPartnerProfile: chatPartnerProfile) else { return }
        
        userDataModel.fetchProfileWithoutImages(uid: uid, completion: { [weak self] profile, error in
                guard let self = self else { return }
                
                if let profile = profile, error == nil {
                    let userName = profile.userName
                    let message = MessageElement(
                        uid: uid,
                        roomID: roomID,
                        isNewMessage: true,
                        name: userName,
                        message: message,
                        createAt: Date()
                    )
                    
                    do {
                        let docmentRef = self.db.collection("chatRoom").document(roomID).collection("messages").document()
                        try docmentRef.setData(from: message)
                    } catch {
                        print(error.localizedDescription)
                    }
                } else if let error = error {
                    print(error.localizedDescription)
                }
            })
    }
    
    /// roomID取得メソッド
    func fetchRoomID(chatPartnerProfile: ProfileElement) -> String? {
        // 自分のUid取得
        var uid: String = ""
        let user = Auth.auth().currentUser
        if let user {
            uid = user.uid
        }
        
        // 相手のUid取得
        guard let chatPartnerUid = chatPartnerProfile.id else { return nil }
        
        // roomID作成
        let roomID = [uid, chatPartnerUid].sorted().joined(separator: "-")
        
        return roomID
    }
}
