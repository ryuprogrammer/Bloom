//
//  MessageElement.swift
//  Bloom
//
//  Created by トム・クルーズ on 2024/02/22.
//

import Foundation
import FirebaseFirestore

struct MessageElement: Codable, Hashable, Identifiable {
    @DocumentID var id: String?
    var uuid = UUID()
    var roomID: String
    var name: String
    var message: String
    var createAt: Date
}
