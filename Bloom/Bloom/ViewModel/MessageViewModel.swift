//
//  MessageViewModel.swift
//  Bloom
//
//  Created by トム・クルーズ on 2024/02/22.
//

import Foundation
import FirebaseFirestore

class MessageViewModel: ObservableObject {
    let userDataModel = UserDataModel()
    let chatDataModel = ChatDataModel()
    @Published var messages: [MessageElement] = []
    
    private var lister: ListenerRegistration?
    let db = Firestore.firestore()
    /// コレクションの名称
    private let collectionName = "chatRoom"
    
    /// roomID取得メソッド
    func fetchRoomID(chatPartnerProfile: ProfileElement) -> String? {
        return chatDataModel.fetchRoomID(chatPartnerProfile: chatPartnerProfile)
    }
    
    /// 最初に全てのmessagesを取得
    func fetchMessages(chatPartnerProfile: ProfileElement) {
        guard let roomID = fetchRoomID(chatPartnerProfile: chatPartnerProfile) else { return }
        
        do {
            let querySnapshot = try db.collection(collectionName).getDocuments()
        }
    }
    
    /// roomIDを指定してmessagesを更新
    func fetchRoomIDMessages(chatPartnerProfile: ProfileElement) {
        guard let roomID = fetchRoomID(chatPartnerProfile: chatPartnerProfile) else { return }
        // 以前のリスナーを削除
        lister?.remove()
        
        // 新しいクエリとリスナーの設定
        /// ここで、messagesから、roomIDが一致するもののみを選別する
        lister = db.collection(collectionName).document(roomID)
            .addSnapshotListener { [weak self] (documentSnapshot, error) in
            guard let self = self else { return }
            
            if let error {
                print(error.localizedDescription)
                return
            }
            
            guard let documentSnapshot = documentSnapshot else {
                print("Error fetching docment: Docment snapshot is nil or not exist")
                return
            }
            
            do {
                // Codableを使って構造体に変換
                let message = try documentSnapshot.data(as: MessageElement.self)
                self.messages.append(message)
            } catch {
                print(error.localizedDescription)
            }
            
            // 日付順に並び替える
            self.messages.sort { before, after in
                return before.createAt < after.createAt
            }
        }
    }
    
    deinit {
        lister?.remove()
    }
    
    func addMessage(chatPartnerProfile: ProfileElement, message: String) async {
        await chatDataModel.addMessage(
            chatPartnerProfile: chatPartnerProfile,
            message: message
        )
    }
    
    func fetchProfile() async throws -> ProfileElement? {
        do {
            return try await userDataModel.fetchProfile()
        } catch {
            print(error.localizedDescription)
        }
        
        return nil
    }
}
