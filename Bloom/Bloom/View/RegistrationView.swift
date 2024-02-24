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
    @State var isShowNextView: Bool = false
    /// 入力完了を監視
    @State var isDoneType: Bool = false
    ///  ユーザーネーム
    @State var userName = ""
    
    var body: some View {
        if isShowNextView {
            HomeView()
        } else {
            NavigationStack {
                ZStack {
                    VStack {
                        Text("名前")
                        TextField("名前を入力", text: $userName)
                            .frame(width: 200)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .onSubmit {
                                withAnimation {
                                    isDoneType = true
                                }
                            }
                    }
                    
                    VStack {
                        Spacer()
                        
                        if isDoneType {
                            Button(action: {
                                // プロフィール登録
                                registrationVM.addProfile(
                                    userName: userName,
                                    age: 23,
                                    gender: .men
                                )
                                isShowNextView = true
                            }, label: {
                                Text("アプリスタート")
                                    .font(.title2)
                                    .foregroundStyle(Color.white)
                                    .padding(12)
                                    .background(Color.cyan)
                                    .clipShape(Capsule())
                            })
                            .padding(.vertical, 50)
                        }
                    }
                }
                .navigationTitle("プロフィール")
            }
        }
    }
}

#Preview {
    RegistrationView()
}
