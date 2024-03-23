//
//  SingleRegistrationView.swift
//  Bloom
//
//  Created by トム・クルーズ on 2024/02/29.
//

import SwiftUI

struct SingleRegistrationView: View {
    var body: some View {
        VStack {
            Text("ユーザー登録")
                .font(.title2)
            
            HStack {
                Circle()
                    .frame(width: 20, height: 20)
            }
        }
    }
}

#Preview {
    SingleRegistrationView()
}
