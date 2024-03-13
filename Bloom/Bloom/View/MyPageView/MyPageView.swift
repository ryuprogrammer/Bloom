import SwiftUI
import PhotosUI
import SwiftData

struct MyPageView: View {
    // MARK: - インスタンス
    @ObservedObject var myPageVM = MyPageViewModel()
    let authenticationManager = AuthenticationManager()
    let userDefaultsDataModel = UserDefaultsDataModel()
    
    // MARK: - UI用サイズ指定
    let iconSize = UIScreen.main.bounds.width / 14
    /// 画面横幅取得→写真の横幅と縦幅に利用
    let homeImageSize = UIScreen.main.bounds.width / 3
    let imageWidth = UIScreen.main.bounds.width / 3 - 20
    let imageHeight = UIScreen.main.bounds.height / 5
    
    // MARK: - 画面遷移
    @State private var navigationPath: [MyPagePath] = []
    
    // MARK: - その他
    @State var showingProfile = ProfileElement(
        userName: "もも",
        introduction: "自己紹介文自己紹介文自己紹介",
        birth: "20000421",
        gender: .men,
        address: "栃木県🍓",
        profileImages: [],
        homeImage: Data()
    )
    // ニックネームの入力値
    @State var editName: String = ""
    // Home写真に関するプロパティ
    @State var selectedItem: PhotosPickerItem?
    // LazyVGridのcolumns
    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            List {
                // ホーム写真
                VStack(alignment: .center) {
                    homeImageView()
                    
                    Text(showingProfile.userName)
                        .font(.largeTitle)
                    
                    Text(showingProfile.birth.toAge() + "・" + showingProfile.address)
                }
                .frame(maxWidth: .infinity)
                .listRowSeparator(.hidden)
                
                Section {
                    HStack {
                        Text("ニックネーム")
                            .foregroundStyle(Color.gray)
                        
                        Spacer()
                        
                        TextField("ニックネームを入力", text: $editName)
                        // TextFieldを右寄せにする
                        .multilineTextAlignment(TextAlignment.trailing)
                        .onSubmit {
                            showingProfile.userName = editName
                        }
                    }
                    
                    NavigationLink(value: MyPagePath.pathAddress) {
                        ProfileRow(title: "居住地", detail: showingProfile.address)
                    }
                    
                    NavigationLink(value: MyPagePath.pathBirth) {
                        ProfileRow(title: "生年月日", detail: showingProfile.birth)
                    }
                } header: {
                    Text("プロフィール情報")
                }
                
                Section {
                    NavigationLink(value: MyPagePath.pathIntroduction) {
                        Text(showingProfile.introduction)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                } header: {
                    Text("自己紹介文")
                }
                
                Section {
                    NavigationLink(value: MyPagePath.pathImage) {
                        LazyVGrid(columns: columns) {
                            ForEach(showingProfile.profileImages, id: \.self) { image in
                                    DataImage(dataImage: image)
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: imageWidth, height: imageHeight)
                                    .background(Color.blue)
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                } header: {
                    Text("プロフィール写真")
                }
            }
            .listStyle(PlainListStyle())
            .navigationBarTitle("マイページ", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        authenticationManager.deleteUser()
                        userDefaultsDataModel.deleteMyProfile()
                    } label: {
                        Text("アカウント削除")
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Image(systemName: "gearshape")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: iconSize)
                        .foregroundStyle(Color.white)
                }
            }
            // 画面遷移を制御
            .navigationDestination(for: MyPagePath.self) { value in
                switch value {
                case .pathImage:
                    ProfileImageEditView(profileImages: $showingProfile.profileImages, path: $navigationPath).toolbar(.hidden, for: .tabBar)
                case .pathIntroduction:
                    IntroductionEditView(introduction: $showingProfile.introduction, path: $navigationPath).toolbar(.hidden, for: .tabBar)
                case .pathAddress:
                    AddressEditView(address: $showingProfile.address, path: $navigationPath).toolbar(.hidden, for: .tabBar)
                case .pathBirth:
                    BirthEditView(birth: $showingProfile.birth, path: $navigationPath).toolbar(.hidden, for: .tabBar)
                }
            }
        }.onAppear { // profile取得
            myPageVM.fetchMyProfile()
        }
        .accentColor(Color.white)
        .onChange(of: myPageVM.myProfile) { // UserDefaultsのprofileを描画
            if let profile = myPageVM.myProfile {
                self.showingProfile = profile
                self.editName = profile.userName
            }
        }
        .onChange(of: showingProfile) { // profileの更新
            guard let dataBaseProfile = myPageVM.myProfile else { return }
            if showingProfile != dataBaseProfile {
                Task {
                    // profileImagesを更新する場合は、一旦firebaseの写真を削除する
                    // firebaseの写真は更新できないため。
                    if showingProfile.profileImages != dataBaseProfile.profileImages {
                        let deleteImageCount = dataBaseProfile.profileImages.count
                        await myPageVM.deleteProfileImages(deleteImageCount: deleteImageCount)
                    }
                    myPageVM.upDateMyProfile(profile: showingProfile)
                }
            }
        }
    }
    
    // ホーム写真
    @ViewBuilder
    func homeImageView() -> some View {
        ZStack {
            Circle()
                .fill(Color.black.opacity(0.2))
                .strokeBorder(Color.black.opacity(0.8), lineWidth: 5)
                .frame(width: homeImageSize, height: homeImageSize)
            
            Image(systemName: "person.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: homeImageSize/2, height: homeImageSize/2)
                .foregroundStyle(Color.white)
            
            DataImage(dataImage: showingProfile.homeImage)
                .aspectRatio(contentMode: .fill)
                .frame(width: homeImageSize, height: homeImageSize)
                .clipShape(Circle())
            
            PhotosPicker(selection: $selectedItem) {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .frame(width: homeImageSize/3, height: homeImageSize/3)
                    .foregroundStyle(Color.pink.opacity(0.8))
                    .background(Color.white)
                    .clipShape(Circle())
            }
            // List全体にあるタップ可能領域を解除
            .buttonStyle(BorderlessButtonStyle())
            .offset(x: homeImageSize/3, y: homeImageSize/3)
            .onChange(of: selectedItem) {
                Task {
                    guard let data = try? await selectedItem?.loadTransferable(type: Data.self) else { return }
                    guard let uiImage = UIImage(data: data) else { return }
                    
                    if let imageData = uiImage.jpegData(compressionQuality: 0.1) {
                        showingProfile.homeImage = imageData
                    }
                }
            }
        }
    }
}

enum MyPagePath {
    case pathImage
    case pathAddress
    case pathBirth
    case pathIntroduction
}

struct ProfileRow: View {
    var title: String
    var detail: String?

    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.gray)
            Spacer()
            if let detail = detail {
                Text(detail)
            }
        }
    }
}

#Preview {
    MyPageView()
}
