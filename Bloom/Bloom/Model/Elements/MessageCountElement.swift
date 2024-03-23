//
//  MessageCountElement.swift
//  Bloom
//
//  Created by トム・クルーズ on 2024/02/27.
//

import Foundation

struct MessageCountElement: Codable, Identifiable {
    var id = UUID()
    let chatPartnerProfile: ProfileElement
    let newMessagesCount: Int
}
