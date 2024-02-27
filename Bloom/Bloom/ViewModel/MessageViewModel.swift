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
            // `messages`サブコレクションからメッセージを取得
            let querySnapshot = try await db.collection(collectionName).document(roomID).collection("messages").order(by: "createAt", descending: false).getDocuments()
            
            DispatchQueue.main.async {
                self.messages = querySnapshot.documents.compactMap { document in
                    try? document.data(as: MessageElement.self)
                }
            }
        } catch {
            print("fetchMessages error: \(error.localizedDescription)")
        }
    }
    
    /// roomIDを指定してmessagesをリアルタイムで更新
    func fetchRoomIDMessages(chatPartnerProfile: ProfileElement) {
        print("メッセージ更新をリアルタイムで取得！")
        guard let roomID = fetchRoomID(chatPartnerProfile: chatPartnerProfile) else { return }
        // 以前のリスナーを削除
        lister?.remove()
        
        // 新しいクエリとリスナーの設定
        lister = db.collection(collectionName).document(roomID).collection("messages")
            .order(by: "createAt", descending: false) // 日付順に並び替え
            .addSnapshotListener { [weak self] (querySnapshot, error) in
                guard let self = self else { return }
                
                if let error {
                    print(error.localizedDescription)
                    return
                }
                
                guard let querySnapshot = querySnapshot else {
                    print("Error fetching documents: Query snapshot is nil")
                    return
                }
                
                // 取得したドキュメントの変更を処理
                querySnapshot.documentChanges.forEach { change in
                    if change.type == .added || change.type == .modified {
                        do {
                            let message = try change.document.data(as: MessageElement.self)
                            if change.type == .added {
                                self.messages.append(message)
                            } else if let index = self.messages.firstIndex(where: { $0.id == message.id }) {
                                self.messages[index] = message
                            }
                        } catch {
                            print("Error decoding message: \(error.localizedDescription)")
                        }
                    }
                }
                
                print("-------------------uuid-------------------")
                for message in messages {
                    print(message.uuid)
                }
                
                // メッセージの変更をViewに通知
                self.isChangeMessages.toggle()
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
        
        print("メッセーじ, VM: \(message)")
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
