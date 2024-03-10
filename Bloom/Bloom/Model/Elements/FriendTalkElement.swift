//
//  FriendTalkElement.swift
//  Bloom
//
//  Created by トム・クルーズ on 2024/03/10.
//

import Foundation
import SwiftData

// FriendListViewで一旦友達を
@Model
class TalkFriendElement {
    let profile: MyProfileElement
    let lastMessage: String?
    let newMessageCount: Int?
    let createAt: Date?
    
    init(profile: MyProfileElement, lastMessage: String?, newMessageCount: Int?, createAt: Date?) {
        self.profile = profile
        self.lastMessage = lastMessage
        self.newMessageCount = newMessageCount
        self.createAt = createAt
    }
}
