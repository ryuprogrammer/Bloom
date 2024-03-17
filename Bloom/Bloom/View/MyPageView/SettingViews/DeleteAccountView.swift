import SwiftUI

struct DeleteAccountView: View {
    let textFileDataModel = TextFileDataModel()
    @State var explanation = ""
    var body: some View {
        ScrollView {
            Text(explanation)
                .padding()
        }
        .navigationBarTitle("退会", displayMode: .inline)
        .onAppear {
            explanation = textFileDataModel.readFile(fileCase: .delete)
        }
    }
}

#Preview {
    DeleteAccountView()
}
