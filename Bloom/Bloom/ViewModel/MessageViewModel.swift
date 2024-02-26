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
    @Published var isChangeMessages: Bool = false
    
    private var lister: ListenerRegistration?
    let db = Firestore.firestore()
    /// コレクションの名称
    private let collectionName = "chatRoom"
    
    /// roomID取得メソッド
    func fetchRoomID(chatPartnerProfile: ProfileElement) -> String? {
        return chatDataModel.fetchRoomID(chatPartnerProfile: chatPartnerProfile)
    }
    
    // TODO: - リファクタ（Dispatchが３つある）
    /// 最初に全てのmessagesを取得
    func fetchMessages(chatPartnerProfile: ProfileElement) async {
        DispatchQueue.main.async {
            self.messages.removeAll()
        }
        guard let roomID = fetchRoomID(chatPartnerProfile: chatPartnerProfile) else { return }
        
        do {
            let querySnapshot = try await db.collection(collectionName).whereField("roomID", isEqualTo: roomID).getDocuments()
            
            DispatchQueue.main.async {
                for docment in querySnapshot.documents {
                    print("docment: \(docment)")
                    do {
                        let message = try docment.data(as: MessageElement.self)
                        print("message: \(message)")
                        self.messages.append(message)
                    } catch {
                        print("fetchMessages error: \(error.localizedDescription)")
                    }
                }
            }
        } catch {
            print("fetchMessages error: \(error.localizedDescription)")
        }
        
        DispatchQueue.main.async {
            // 日付順に並び替える
            self.messages.sort { before, after in
                return before.createAt < after.createAt
            }
        }
    }
    
    /// roomIDを指定してmessagesを更新
    func fetchRoomIDMessages(chatPartnerProfile: ProfileElement) {
        print("メッセージ更新を取得！")
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
        
        // メッセージの変更をViewに通知
        isChangeMessages.toggle()
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
