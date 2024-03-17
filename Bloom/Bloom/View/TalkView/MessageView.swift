import SwiftUI

struct MessageView: View {
    let chatPartnerProfile: ProfileElement
    @ObservedObject var messageVM = MessageViewModel()
    @State private var typeMessage = ""
    @State private var isSendMessage: Bool = false
    @State private var sendButtonAnimate: Bool = false
    @FocusState private var keybordFocus: Bool
    @State var isShowProfile: Bool = false
    let iconSize = UIScreen.main.bounds.width / 14
    @State var showActionSheet: Bool = false
    @State var isShowBlock: Bool = false
    @State var isShowReport: Bool = false

    var body: some View {
        VStack {
            ScrollViewReader { proxy in
                List(messageVM.messages, id: \.id) { message in
                    if message.name == chatPartnerProfile.userName { // 相手のメッセージ
                        MessageRowView(
                            message: message,
                            isMyMessage: false,
                            friendProfile: chatPartnerProfile
                        )
                        .listRowSeparator(.hidden)
                    } else { // 自分のメッセージ
                        MessageRowView(
                            message: message,
                            isMyMessage: true,
                            friendProfile: nil
                        )
                        .listRowSeparator(.hidden)
                    }
                }
                .listStyle(PlainListStyle())
                .navigationBarTitle(chatPartnerProfile.userName, displayMode: .inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text(chatPartnerProfile.userName)
                            .foregroundStyle(Color.white)
                            .onTapGesture {
                                isShowProfile = true
                            }
                            .sheet(isPresented: $isShowProfile) {
                                FriendPreviewView(
                                    profile: chatPartnerProfile
                                )
                            }
                    }

                    // 友達をブロック、通報
                    ToolbarItem(placement: .topBarTrailing) {
                        Image(systemName: "exclamationmark.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: iconSize, height: iconSize)
                            .foregroundStyle(Color.white)
                            .onTapGesture {
                                showActionSheet = true
                            }
                            .confirmationDialog("", isPresented: $showActionSheet, titleVisibility: .hidden) {
                                        Button("友達をブロックする") {
                                            isShowBlock = true
                                        }
                                        Button("友達を通報する") {
                                            isShowReport = true
                                        }
                                    }
                            .alert("友達をブロック", isPresented: $isShowBlock) {
                                Button("ブロック", role: .destructive) {
                                    messageVM.changeFriendStatus(
                                        state: .blockByMy,
                                        friendProfile: chatPartnerProfile
                                    )
                                }
                            } message: {
                                Text("友達とのマッチングが解消されます")
                            }
                            .alert("友達を通報", isPresented: $isShowReport) {
                                Button("通報", role: .destructive) {
                                    messageVM.changeFriendStatus(
                                        state: .reportByFriend,
                                        friendProfile: chatPartnerProfile
                                    )
                                }
                            } message: {
                                Text("悪質なユーザーであれば、\n「マイページ」→「お問い合わせ」\nから報告してください。")
                            }
                    }
                }
                .onChange(of: messageVM.messages) {
                    withAnimation {
                        if let lastMessage = messageVM.messages.last {
                            proxy.scrollTo(lastMessage.id, anchor: .bottom)
                        }
                    }
                }
            }
            
            HStack {
                TextField("メッセージを入力", text: $typeMessage)
                    .padding(.horizontal)
                    .frame(height: iconSize)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.cyan, lineWidth: 1)
                    )
                    .focused(self.$keybordFocus)
                    .onChange(of: typeMessage) {
                        if typeMessage != "" {
                            isSendMessage = true
                        } else {
                            isSendMessage = false
                        }
                    }
                
                Button(action: {
                    if isSendMessage {
                        sendButtonAnimate.toggle()
                        
                        // メッセージ追加
                        messageVM.addMessage(
                            chatPartnerProfile: chatPartnerProfile,
                            message: typeMessage
                        )
                        typeMessage = ""
                        keybordFocus = false
                    }
                }, label: {
                    Image(systemName: "paperplane.circle.fill")
                        .resizable()
                        .frame(width: iconSize, height: iconSize)
                        .foregroundStyle(isSendMessage ? Color.cyan : Color.gray)
                        .symbolEffect(.bounce.down.byLayer, value: sendButtonAnimate)
                })
                .disabled(!isSendMessage)
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
        }
        .onAppear {
            Task {
                await messageVM.fetchMessages(chatPartnerProfile: chatPartnerProfile)
                await messageVM.changeMessage(chatPartnerProfile: chatPartnerProfile)
            }
            
            // chatPartnerProfileからmessagesを取得
            messageVM.fetchRoomIDMessages(chatPartnerProfile: chatPartnerProfile)
        }
    }
}

#Preview {
    MessageView(
        chatPartnerProfile:
            ProfileElement(
                userName: "もも",
                introduction: "",
                birth: "",
                gender: .men,
                address: "栃木県",
                profileImages: [],
                homeImage: Data()
            )
    )
}
