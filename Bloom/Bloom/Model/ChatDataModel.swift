//
//  ChatDataModel.swift
//  Bloom
//
//  Created by トム・クルーズ on 2024/02/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class ChatDataModel {
    let userDataModel = UserDataModel()
    private var db = Firestore.firestore()
    let countCollectionName = "newMessageCount"
    /// チャットを追加
    func addMessage(chatPartnerProfile: ProfileElement, message: String) async {
        // 自分のUid取得
        var uid: String = ""
        
        let user = Auth.auth().currentUser
        
        if let user {
            uid = user.uid
        }
        
        guard let roomID = fetchRoomID(chatPartnerProfile: chatPartnerProfile) else { return }
        do {
            guard let userName = try await userDataModel.fetchProfile()?.userName else { return }
            
            let message = MessageElement(
                uid: uid,
                roomID: roomID,
                isNewMessage: true,
                name: userName,
                message: message,
                createAt: Date()
            )
            
            let docmentRef = db.collection("chatRoom").document(roomID).collection("messages").document()
            try docmentRef.setData(from: message)
        } catch {
            print(error.localizedDescription)
        }
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
