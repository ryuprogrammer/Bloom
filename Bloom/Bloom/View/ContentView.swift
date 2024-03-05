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
                if authenticationManager.accountStatus == .none {
                    SignInView(isShowSheet: $isShowSheet)
                } else if authenticationManager.accountStatus == .existsNoProfile || authenticationManager.accountStatus == .mismatchID {
                    // Profileは存在してないのでProfile作成
                    RegistrationView()
                } else if authenticationManager.accountStatus == .valid {
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
