//
//  FriendsElemt.swift
//  Bloom
//
//  Created by トム・クルーズ on 2024/03/03.
//

import Foundation
import FirebaseFirestore

struct FriendsElement: Codable {
    @DocumentID var id: String?
    var friendUid: String
    var status: FriendStatus
}

enum FriendStatus: String, Codable {
    /// マッチした人: トーク画面などで使用→ 両方
    case matchd = "マッチした人"
    /// ライクされた人: 相手からのライク確認画面で使用→ 相手
    case likeByFriend = "ライクされた人"
    /// ライクした人: SwipeViewに再表示しないために使用→ 自分
    case likeByMe = "ライクした人"
    /// アンライクした人: 二度と表示しないために使用→ 自分
    case unLikeByMe = "アンライクした人"
    /// ブロックされた人→ 相手
    case blockByFriend = "ブロックされた人"
    /// ブロックした人→ 自分
    case blockByMy = "ブロックした人"
    
    var id: String { rawValue }
}
