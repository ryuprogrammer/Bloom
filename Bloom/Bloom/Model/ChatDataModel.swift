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
    
    /// チャットのルームが存在するか確認
    func isExistChatRoom() {
        
    }
    
    /// チャットのルーム作成
    func addMessage(chatPartnerProfile: ProfileElement, message: String) async {
        do {
            guard let userName = try await userDataModel.fetchProfile()?.userName else { return }
            
            let message = MessageElement(
                name: userName,
                message: message,
                createAt: Date()
            )
            
            var uid: String = ""
            
            guard let chatPartnerUid = chatPartnerProfile.id else { return }
            
            let user = Auth.auth().currentUser
            
            if let user {
                uid = user.uid
            }
            
            let roomID = [uid, chatPartnerUid].sorted().joined(separator: "-")
            print("roomID: \(roomID)")
            
            try db.collection("chatRoom").document(roomID).setData(from: message)
        } catch {
            print(error.localizedDescription)
        }
    }
}
