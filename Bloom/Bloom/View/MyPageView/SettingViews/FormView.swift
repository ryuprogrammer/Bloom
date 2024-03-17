//
//  FormView.swift
//  Bloom
//
//  Created by トム・クルーズ on 2024/03/17.
//

import SwiftUI

struct FormView: View {
    var body: some View {
        if let urlString = URL(string: "https://forms.gle/NMSLZvyArpTFosuG8") {
            SafariView(url: urlString)
                .ignoresSafeArea()
        }
    }
}

#Preview {
    FormView()
}
