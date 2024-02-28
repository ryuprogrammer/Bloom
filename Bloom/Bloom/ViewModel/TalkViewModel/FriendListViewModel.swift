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
    private var listener: ListenerRegistration?
    let db = Firestore.firestore()
    /// コレクションの名称
    private let collectionName = "chatRoom"
    let mostLongStringNumber: Int = 16
    
    deinit {
        listener?.remove()
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
    
    /// roomIDを指定して未読メッセージ数をリアルタイムで更新
//    func fetchNewMessageCount(chatPartnerProfile: ProfileElement) {
//        self.newMessageCount = 0
//        guard let roomID = fetchRoomID(chatPartnerProfile: chatPartnerProfile) else { return }
//        // 以前のリスナーを削除
//        listener?.remove()
//        
//        guard let partnerUid = chatPartnerProfile.id else { return }
//        
//        // 新しいクエリとリスナーの設定
//        listener = db.collection(collectionName).document(roomID).collection("messages")
//            .addSnapshotListener { [weak self] (querySnapshot, error) in
//                guard let self = self else { return }
//                
//                if let error = error {
//                    print(error.localizedDescription)
//                    return
//                }
//                
//                guard let querySnapshot = querySnapshot else {
//                    print("Error fetching documents: Query snapshot is nil")
//                    return
//                }
//                
//                // 取得したドキュメントの変更を処理
//                let newMessages = querySnapshot.documentChanges.filter { change in
//                    change.type == .added || change.type == .modified
//                }.compactMap { change -> MessageElement? in
//                    try? change.document.data(as: MessageElement.self)
//                }.filter { message in
//                    message.isNewMessage == true && message.uid == partnerUid
//                }
//                
//                // 新規メッセージをカウント
//                DispatchQueue.main.async {
//                    self.newMessageCount = newMessages.count
//                    print("相手（り）\(chatPartnerProfile.userName)")
//                    print("newMessageCount（り）: \(self.newMessageCount)")
//                }
//            }
//    }
    
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
