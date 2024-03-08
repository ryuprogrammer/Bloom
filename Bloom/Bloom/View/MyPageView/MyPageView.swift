import SwiftUI

struct MyPageView: View {
    
    let iconSize = UIScreen.main.bounds.width / 14
    
    @State var showingView: ShowingViewState = .edit
    
    enum ShowingViewState: String {
        case edit = "編集"
        case preview = "プレビュー"
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .center) {
                HStack { // HStackの間隔を調整
                    ForEach([ShowingViewState.edit, ShowingViewState.preview], id: \.self) { state in
                        Text(state.rawValue)
                            .foregroundColor(state == showingView ? .black : .gray)
                            .font(.title2)
                            .onTapGesture {
                                withAnimation {
                                    showingView = state
                                }
                            }
                    }
                }
                .frame(height: 50)
                
                if showingView == .edit {
                    MyPageEditView()
                } else if showingView == .preview {
                    
                }
            }
            .frame(maxWidth: .infinity) // 幅を最大に設定
            .navigationBarTitle("マイページ", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Image(systemName: "questionmark.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: iconSize, height: iconSize) // アイコンサイズ調整
                        .foregroundColor(Color.white)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Image(systemName: "slider.horizontal.3")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: iconSize, height: iconSize) // アイコンサイズ調整
                        .foregroundColor(Color.white)
                }
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        MyPageView()
    }
}
