//
//  ContentView.swift
//  Bloom
//
//  Created by トム・クルーズ on 2024/02/20.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var authenticationManager = AuthenticationManager()
    @State private var isShowSheet = false
    
    var body: some View {
            VStack {
                if authenticationManager.accountStatus == .signOut {
                    Spacer()
                    // Sign-Out状態なのでSign-Inボタンを表示する
                    Button {
                        self.isShowSheet.toggle()
                    } label: {
                        Text("サインインする")
                            .font(.title2)
                            .foregroundStyle(Color.white)
                            .frame(height: 55)
                            .frame(maxWidth: .infinity)
                            .background(Color.pink.opacity(0.8))
                            .clipShape(Capsule())
                            .padding()
                    }
                } else if authenticationManager.accountStatus == .signIn {
                    // Profileは存在してないのでProfile作成
                    RegistrationView()
                } else if authenticationManager.accountStatus == .existProfile {
                    // 正常にアカウントがある
                    HomeView()
                }
            }
            .sheet(isPresented: $isShowSheet) {
                FirebaseAuthUIView()
            }
        }
}

#Preview {
    ContentView()
}
