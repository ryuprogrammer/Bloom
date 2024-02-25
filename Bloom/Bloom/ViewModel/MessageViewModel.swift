//
//  MessageViewModel.swift
//  Bloom
//
//  Created by トム・クルーズ on 2024/02/22.
//

import Foundation
import FirebaseFirestore

/// @Observableを使うことでプロパティ変数messageの変更によって自動でデータが更新
@Observable class MessageViewModel {
    let userDataModel = UserDataModel()
    let chatDataModel = ChatDataModel()
    private(set) var messages: [MessageElement] = []
    
    private var lister: ListenerRegistration?
    /// コレクションの名称
    private let collectionName = "chatRoom"
    
    // 初期化
    init() {
        let db = Firestore.firestore()
        lister = db.collection(collectionName).addSnapshotListener { (querySnapshot, error) in
            if let error {
                print(error.localizedDescription)
                return
            }
            if let querySnapshot {
                for documentChange in querySnapshot.documentChanges {
                    if documentChange.type == .added {
                        do {
                            // Codableを使って構造体に変換する
                            let message = try documentChange.document.data(as: MessageElement.self)
                            self.messages.append(message)
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
                
                // 日付順に並べ替えする
                self.messages.sort { before, after in
                    return before.createAt < after.createAt ? true : false
                }
            }
        }
    }
    
    // 
    
    deinit {
        lister?.remove()
    }
    
    func addMessage(chatPartnerProfile: ProfileElement, message: String) async {
        await chatDataModel.addMessage(chatPartnerProfile: chatPartnerProfile, message: message)
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
