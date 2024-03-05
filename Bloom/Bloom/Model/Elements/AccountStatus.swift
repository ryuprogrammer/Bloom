//
//  AccountStatus.swift
//  Bloom
//
//  Created by トム・クルーズ on 2024/02/25.
//

import Foundation

enum AccountStatus {
    /// 完全にアカウントがない
    case none
    /// アカウントはあるが、プロフィール情報がない
    case existsNoProfile
    /// アカウントもプロフィールも正常にある
    case valid
    /// アカウントもプロフィールもあるが、idが一致しない
    case mismatchID
}

// 完全にアカウントがない
// アカウントはあるが、プロフィール情報がない
// アカウントもプロフィールも正常にある
// アカウントもプロフィールもあるが、idが一致しない

//enum AccountStatus {
//    case signOut
//    case signIn
//    case existProfile
//}
