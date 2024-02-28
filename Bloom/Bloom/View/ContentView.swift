//
//  ContentView.swift
//  Bloom
//
//  Created by トム・クルーズ on 2024/02/20.
//

import SwiftUI

struct ContentView: View {
    private var authenticationManager = AuthenticationManager()
    @State private var isShowSheet = false
    
    var body: some View {
            VStack {
                if authenticationManager.accountStatus == .signOut {
                    // Sign-Out状態なのでSign-Inボタンを表示する
                    Button {
                        self.isShowSheet.toggle()
                    } label: {
                        Text("Sign-In")
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
            .onAppear {
                Task {
                    await authenticationManager.checkAccountStatus()
                }
            }
        }
}

#Preview {
    ContentView()
}
