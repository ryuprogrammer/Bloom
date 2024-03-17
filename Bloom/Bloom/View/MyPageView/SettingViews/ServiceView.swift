import SwiftUI

struct ServiceView: View {
    let textFileDataModel = TextFileDataModel()
    @State var explanation = ""
    var body: some View {
        ScrollView {
            Text(explanation)
                .padding()
        }
        .navigationBarTitle("利用規約", displayMode: .inline)
        .onAppear {
            Task {
                explanation = await textFileDataModel.readFile(fileCase: .service)
            }
        }
    }
}

#Preview {
    ServiceView()
}
