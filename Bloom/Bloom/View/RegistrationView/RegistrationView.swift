//
//  RegistrationView.swift
//  Bloom
//
//  Created by トム・クルーズ on 2024/02/24.
//

import SwiftUI

struct RegistrationView: View {
    fileprivate var registrationVM = RegistrationViewModel()
    /// 画面遷移
    @State var isShowHomeView: Bool = false
    /// 入力完了を監視
    @State var isDoneType: Bool = false
    ///  ユーザーネーム
    @State var userName = ""
    // 名前の入力の完了を監視
    @State var isDoneName: Bool = false
    // プロフィール入力の進行度
    @State var registrationState: RegistrationState = .noting
    // ニックネーム
    @State var name: String = ""
    // 誕生日
    @State var birth: String = "20000421"
    
    var body: some View {
        if registrationState == .noting {
            NameEntryView(
                name: $name,
                registrationState: $registrationState
            )
        } else if registrationState == .name {
            BirthEntryView(
                birth: $birth,
                registrationState: $registrationState
            )
        }
//        if isShowHomeView {
//            HomeView()
//        } else {
//            
//            NavigationStack {
//                ZStack {
//                    VStack {
//                        Text("名前")
//                        TextField("名前を入力", text: $userName)
//                            .frame(width: 200)
//                            .textFieldStyle(RoundedBorderTextFieldStyle())
//                            .onSubmit {
//                                withAnimation {
//                                    isDoneType = true
//                                }
//                            }
//                    }
//                    
//                    VStack {
//                        Spacer()
//                        
//                        if isDoneType {
//                            Button(action: {
//                                // プロフィール登録
//                                registrationVM.addProfile(
//                                    userName: userName,
//                                    age: 23,
//                                    gender: .men
//                                )
//                                isShowHomeView = true
//                            }, label: {
//                                Text("アプリスタート")
//                                    .font(.title2)
//                                    .foregroundStyle(Color.white)
//                                    .padding(12)
//                                    .background(Color.cyan)
//                                    .clipShape(Capsule())
//                            })
//                            .padding(.vertical, 50)
//                        }
//                    }
//                }
//                .navigationTitle("プロフィール")
//            }
//        }
    }
}

enum RegistrationState: Int {
    case noting = 0
    case name = 1
    case birth = 2
    case gender = 3
    case address = 4
    case doneAll = 5
}

#Preview {
    RegistrationView()
}
