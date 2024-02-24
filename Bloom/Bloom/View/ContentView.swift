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
                if authenticationManager.isSignIn == false {
                    // Sign-Out状態なのでSign-Inボタンを表示する
                    Button {
                        self.isShowSheet.toggle()
                    } label: {
                        Text("Sign-In")
                    }
                } else {
                    // 登録画面に遷移
                    RegistrationView()
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
