import SwiftUI
import FirebaseCore
import FirebaseAuthUI
import SwiftData
import UserNotifications
import Firebase
import FirebaseMessaging

@main
struct BloomApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(Color.pink.opacity(0.8)) // 背景色も設定
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white] // タイトルの色を白に設定

        // iOS 15以降、スタイルを適用
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [
            FriendListRowElement.self,
            SwipeFriendElement.self
        ])
    }
}

// MARK: - AppDelegate Main
class AppDelegate: NSObject, UIApplicationDelegate, MessagingDelegate {
    private func app(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()

        return true
    }

    func app(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        let sourceApplication = options[UIApplication.OpenURLOptionsKey.sourceApplication] as! String?
        if FUIAuth.defaultAuthUI()?.handleOpen(url, sourceApplication: sourceApplication) ?? false {
            return true
        }
        // other URL handling goes here.
        return false
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self

        // Push通知許可のポップアップを表示
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { granted, _ in
            guard granted else { return }
            DispatchQueue.main.async {
                application.registerForRemoteNotifications()
            }
        }

        if let apnsToken = Messaging.messaging().apnsToken {
            print("apnsToken: \(apnsToken)")
        } else {
            print("apnsTokenが取得できなかったお")
        }

        // 現在のトークンを取得
        Messaging.messaging().token { token, error in
          if let error = error {
            print("Error fetching FCM registration token: \(error)")
          } else if let token = token {
            print("FCM registration token: \(token)")
            print("Remote FCM registration token: \(token)")
          }
        }
        return true
    }
}

// MARK: - AppDelegate Push Notification
extension AppDelegate: UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // メソッドが呼び出されたことをログに出力する
        print("didReceiveRemoteNotification method called")

        if let messageID = userInfo["gcm.message_id"] {
            print("MessageID: \(messageID)")
        }
        print(userInfo)
        completionHandler(.newData)
    }


    // アプリがForeground時にPush通知を受信する処理
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }

    // アプリ起動時にFCM Tokenを取得、その後RDBのusersツリーにTokenを保存
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let fcmToken = fcmToken else { return }
        print("uid取得するよーーーーーーーーーー")
        if let uid = Auth.auth().currentUser?.uid {
            setFcmToken(uid: uid, fcmToken: fcmToken)
        } else {
            print("uid取得できなかったお")
        }
    }

    // FCM Tokenをuidに紐付けておく
    func setFcmToken(uid: String, fcmToken: String) {
        print("セットするよー")
        guard !uid.isEmpty else {
            print("Error: UID is empty.")
            return
        }

        let value = ["fcmToken": fcmToken]
        let ref = Database.database().reference().child("users").child(uid).child("fcmToken")

        ref.setValue(value) { error, _ in
            if let error = error {
                print("Error updating FCM Token: \(error.localizedDescription)")
            } else {
                print("FCM Token updated successfully.")
            }
        }
    }
}
