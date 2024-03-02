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
    @State var registrationState: RegistrationState = .name
    // ニックネーム
    @State var name: String = ""
    // 誕生日
    @State var birth: String = ""
    // 性別
    @State var gender: Gender = .men
    // 居住地
    @State var address: String = ""
    // プロフィール写真
    @State var profileImages: [Data] = []
    // ホーム写真
    @State var homeImage: Data = Data()
    
    var body: some View {
        if registrationState == .name {
            NameEntryView(
                name: $name,
                registrationState: $registrationState
            )
        } else if registrationState == .birth {
            BirthEntryView(
                birth: $birth,
                registrationState: $registrationState
            )
        } else if registrationState == .gender {
            GenderEntryView(
                selectedGender: $gender,
                registrationState: $registrationState
            )
        } else if registrationState == .address {
            AddressEntryView(
                address: $address,
                registrationState: $registrationState
            )
        } else if registrationState == .profileImage {
            ProfileImageEntryView(
                profileImages: $profileImages,
                registrationState: $registrationState
            )
        } else if registrationState == .homeImage {
            HomeImageEntryView(
                homeImage: $homeImage,
                registrationState: $registrationState
            )
        } else if registrationState == .doneAll {
            VStack {
                Text("Bloomをはじめよう")
                
                Spacer()
                
                Button(action: {
                    withAnimation {
                        registrationVM.addProfile(
                            userName: name,
                            birth: birth,
                            gender: gender,
                            address: address,
                            profileImages: profileImages,
                            homeImage: homeImage
                        )
                        
                        registrationState = .toHome
                    }
                }, label: {
                    Text("アプリをはじめる")
                        .font(.title2)
                        .foregroundStyle(Color.white)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(Color.pink.opacity(0.8))
                        .clipShape(Capsule())
                        .padding()
                })
            }
        } else if registrationState == .toHome {
            HomeView()
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
    case profileImage = 5
    case homeImage = 6
    case doneAll = 7
    case toHome = 8
}

#Preview {
    RegistrationView()
}
