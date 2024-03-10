//
//  SwiftDataModel.swift
//  Bloom
//
//  Created by トム・クルーズ on 2024/03/09.
//

import Foundation
import SwiftData

struct SwiftDataModel {
    // TalkFriendElementの全削除
    func deleteData(context: ModelContext) {
        do {
            try context.delete(model: TalkFriendElement.self, includeSubclasses: true)
        } catch {
            print("SwiftDataの削除でエラー: \(error.localizedDescription)")
        }
    }
    
    // TalkFriendElementの追加
    func addTalkFriend(
        context: ModelContext,
        profile: ProfileElement,
        lastMessage: String,
        newMessageCount: Int,
        createAt: Date
    ) {
        guard let id = profile.id else {
            print("idがダメだーーーーーーーーーーーーーーー")
            return
        }
        
        let newProfile = MyProfileElement(
            id: id,
            userName: profile.userName,
            introduction: profile.introduction,
            birth: profile.birth,
            gender: profile.gender,
            address: profile.address,
            profileImages: profile.profileImages,
            homeImage: profile.homeImage
        )
        
        print("ここーーーーーーー＝＝ーーーーーーーーーーー＝！")
        let data = TalkFriendElement(
            profile: newProfile,
            lastMessage: lastMessage,
            newMessageCount: newMessageCount,
            createAt: createAt
        )
        
        context.insert(data)
        do {
            try context.save()
            print("追加成功ーーーーーーーーーーーーーーーーーーーーー！")
        } catch {
            print(error.localizedDescription)
        }
    }
}
