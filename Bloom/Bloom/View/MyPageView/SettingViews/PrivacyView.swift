import SwiftUI

struct PrivacyView: View {
    let textFileDataModel = TextFileDataModel()
    @State var explanation = ""
    var body: some View {
        ScrollView {
            Text(explanation)
                .padding()
        }
        .navigationBarTitle("プライバシーポリシー", displayMode: .inline)
        .onAppear {
            Task {
                explanation = await textFileDataModel.readFile(fileCase: .privacy)
            }
        }
    }
}

#Preview {
    PrivacyView()
}
