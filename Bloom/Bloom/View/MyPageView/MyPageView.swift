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
    @State var showingProfile: ProfileElement = mockProfileData
    // ニックネームの入力値
    @State var editName: String = ""
    // Home写真に関するプロパティ
    @State var selectedItem: PhotosPickerItem?
    // LazyVGridのcolumns
    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)

    var body: some View {
        NavigationStack(path: $navigationPath) {
            List {
                // ホーム写真と基本情報
                VStack(alignment: .center) {
                    // ホーム写真
                    homeImageView()

                    Text(showingProfile.userName)
                        .font(.largeTitle)

                    Text(showingProfile.birth.toAge() + "・" + showingProfile.address)
                }
                .frame(maxWidth: .infinity)
                .listRowSeparator(.hidden)

                // プロフィール情報セクション
                profileInformation()

                // 自己紹介文セクション
                introduction()

                // プロフィール写真セクション
                profileImages()
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
                    Button {
                        navigationPath.append(.pathSetting)
                    } label: {
                        Image(systemName: "gearshape")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: iconSize)
                            .foregroundStyle(Color.white)
                    }
                }
            }
            // 画面遷移を制御
            .navigationDestination(for: MyPagePath.self, destination: navigationDestination)
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

// MARK: - セクション毎のViewBuilder達
    // ホーム写真
    @ViewBuilder
    func homeImageView() -> some View {
        ZStack {
            Circle()
                .fill(Color.black.opacity(0.2))
                .strokeBorder(Color.black.opacity(0.8), lineWidth: 5)
                .frame(width: homeImageSize, height: homeImageSize)

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

    // プロフィール
    @ViewBuilder
    func profileInformation() -> some View {
        Section {
            HStack {
                ListRowView(
                    viewType: .MyPageView,
                    image: "person.text.rectangle",
                    title: "ニックネーム"
                )

                Spacer()

                TextField("ニックネームを入力", text: $editName)
                    .foregroundStyle(Color.pink)
                // TextFieldを右寄せにする
                .multilineTextAlignment(TextAlignment.trailing)
                .onSubmit {
                    showingProfile.userName = editName
                }
            }

            NavigationLink(value: MyPagePath.pathAddress) {
                ListRowView(
                    viewType: .MyPageView,
                    image: "mappin.and.ellipse",
                    title: "居住地",
                    detail: showingProfile.address
                )
            }

            NavigationLink(value: MyPagePath.pathBirth) {
                ListRowView(
                    viewType: .MyPageView,
                    image: "birthday.cake",
                    title: "生年月日",
                    detail: showingProfile.birth
                )
            }
        } header: {
            Text("プロフィール情報")
        }
    }

    // 自己紹介文
    @ViewBuilder
    func introduction() -> some View {
        Section {
            NavigationLink(value: MyPagePath.pathIntroduction) {
                ListRowView(
                    viewType: .MyPageView,
                    image: "pencil.line"
                )
                Text(showingProfile.introduction ?? "")
                    .fixedSize(horizontal: false, vertical: true)
            }
        } header: {
            Text("自己紹介文")
        }
    }

    // プロフィール写真
    @ViewBuilder
    func profileImages() -> some View {
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

    // MARK: - 画面遷移メソッド
    @ViewBuilder
    func navigationDestination(for path: MyPagePath) -> some View {
        switch path {
        case .pathImage:
            ProfileImageEditView(profileImages: $showingProfile.profileImages, path: $navigationPath).toolbar(.hidden, for: .tabBar)
        case .pathIntroduction:
            IntroductionEditView(introduction: $showingProfile.introduction, path: $navigationPath).toolbar(.hidden, for: .tabBar)
        case .pathAddress:
            AddressEditView(address: $showingProfile.address, path: $navigationPath).toolbar(.hidden, for: .tabBar)
        case .pathBirth:
            BirthEditView(birth: $showingProfile.birth, path: $navigationPath).toolbar(.hidden, for: .tabBar)
        case .pathSetting:
            SettingView(path: $navigationPath).toolbar(.hidden, for: .tabBar)
        case .pathPrivacy:
            PrivacyView().toolbar(.hidden, for: .tabBar)
        case .pathService:
            ServiceView().toolbar(.hidden, for: .tabBar)
        case .pathForm:
            FormView().toolbar(.hidden, for: .tabBar)
        case .pathDeleteAccount:
            DeleteAccountView().toolbar(.hidden, for: .tabBar)
        }
    }
}

enum MyPagePath {
    case pathImage
    case pathAddress
    case pathBirth
    case pathIntroduction
    case pathSetting
    case pathPrivacy
    case pathService
    case pathForm
    case pathDeleteAccount
}

#Preview {
    MyPageView()
}

