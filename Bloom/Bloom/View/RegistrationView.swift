//
//  RegistrationView.swift
//  Bloom
//
//  Created by トム・クルーズ on 2024/02/24.
//

import SwiftUI

struct RegistrationView: View {
    @State var name = ""
    @State var birthDate = Date()
    @State var gender: Gender = .men
    @State var matchGender: Gender = .wemen
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    TextField("名前を入力", text: $name)
                } header: {
                    Text("名前")
                }
            }
            .navigationTitle("プロフィール")
        }
    }
}

enum Gender: String {
    case men = "男性"
    case wemen = "女性"
}

#Preview {
    RegistrationView()
}
