import SwiftUI
import PhotosUI

struct MyPageEditView: View {
    @ObservedObject var myPageVM = MyPageViewModel()
    @State var profile = ProfileElement(
        userName: "もも",
        introduction: "自己紹介文自己紹介文自己紹介",
        birth: "20000421",
        gender: .men,
        address: "栃木県🍓",
        profileImages: [Data(), Data(), Data(), Data()],
        homeImage: Data()
    )
    @State var editName: String = ""
    
    // Home写真に関するプロパティ
    @State var selectedItem: PhotosPickerItem?
    @State var uiImage: UIImage = UIImage()
    @State var homeImage: Data = Data()
    @State var isImageValid: Bool = false
    // 画面横幅取得→写真の横幅と縦幅に利用
    let homeImageSize = UIScreen.main.bounds.width / 3
    let imageWidth = UIScreen.main.bounds.width / 3 - 13
    let imageHeight = UIScreen.main.bounds.height / 5
    // 画面遷移に関するプロパティ
    @State var isShowProfileImageEditView: Bool = false
    @State var isSHowIntroductionEditView: Bool = false
    
    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    
    @State var t: RegistrationState = .noting
    @State private var navigationPath: [MyPagePath] = []
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            List {
                // ホーム写真
                VStack(alignment: .center) {
                    homeImageView()
                    
                    Text(profile.userName)
                        .font(.largeTitle)
                    
                    Text(profile.birth.toAge())
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
                            profile.userName = editName
                        }
                    }
                    
                    NavigationLink(value: MyPagePath.pathAddress) {
                        ProfileRow(title: "居住地", detail: profile.address)
                    }
                    
                    NavigationLink(value: MyPagePath.pathBirth) {
                        ProfileRow(title: "生年月日", detail: profile.birth)
                    }
                } header: {
                    Text("プロフィール情報")
                }
                
                Section {
                    NavigationLink(value: MyPagePath.pathIntroduction) {
                        Text(profile.introduction)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                } header: {
                    Text("自己紹介文")
                }
                
                Section {
                    NavigationLink(value: MyPagePath.pathImage) {
                        VStack {
                            LazyVGrid(columns: columns) {
                                ForEach(profile.profileImages, id: \.self) { image in
                                        DataImage(dataImage: image)
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: imageWidth, height: imageHeight)
                                        .background(Color.blue)
                                        .clipShape(RoundedRectangle(cornerRadius: 20))
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.horizontal)
                } header: {
                    Text("プロフィール写真")
                }

            }
            .listStyle(PlainListStyle())
            // 画面遷移を制御
            .navigationDestination(for: MyPagePath.self) { value in
                switch value {
                case .pathImage:
                    ProfileImageEditView(profileImages: $profile.profileImages, path: $navigationPath)
                case .pathIntroduction:
                    IntroductionEditView(introduction: $profile.introduction, path: $navigationPath)
                case .pathAddress:
                    AddressEditView(address: $profile.address, path: $navigationPath)
                case .pathBirth:
                    BirthEditView(birth: $profile.birth, path: $navigationPath)
                }
            }
        }
        .onChange(of: profile) {
            if profile != myPageVM.myProfile {
                print("myPageVM.upDateMyProfile()")
                myPageVM.upDateMyProfile(profile: profile)
            }
        }
        .onChange(of: myPageVM.myProfile) {
            print("profile = myPageVM.myProfile")
            if let profile = myPageVM.myProfile {
                self.profile = profile
                self.editName = profile.userName
            }
        }
        .onAppear {
            // profile取得
            myPageVM.fetchMyProfile()
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
            
            DataImage(dataImage: profile.homeImage)
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
                    self.uiImage = uiImage
                    
                    if let imageData = uiImage.jpegData(compressionQuality: 0.1) {
                        homeImage = imageData
                    }
                }
                isImageValid = true
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
    MyPageEditView()
}
