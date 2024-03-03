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
    var friedUid: String
    var status: FriendEditState
}

enum FriendEditState: Codable {
    /// マッチした人: トーク画面などで使用→ 両方
    case matchd
    /// ライクされた人: 相手からのライク確認画面で使用→ 相手
    case likeByFriend
    /// ライクした人: SwipeViewに再表示しないために使用→ 自分
    case likeByMe
    /// アンライクした人: 二度と表示しないために使用→ 自分
    case unLikeByMe
    /// ブロックされた人→ 相手
    case blockByFriend
    /// ブロックした人→ 自分
    case blockByMy
}
