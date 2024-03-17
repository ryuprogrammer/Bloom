import SwiftUI

struct FormView: View {
    var body: some View {
        if let urlString = URL(string: "https://forms.gle/bavw6nRSzrfkCz8o7") {
            SafariView(url: urlString)
                .ignoresSafeArea()
        }
    }
}

#Preview {
    FormView()
}
