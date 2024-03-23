import Foundation


class PushNotificationSender {
    init() {}
    private let FCM_serverKey = "AAAAPcsgmXU:APA91bEtplSmNehdj9_fe9VWxP6Fw2NI-29_yLZFDuskDTBYU6vUR_0nt3i2i5vevsKikHFEUxVxTl-3qVMkmrzbUHMdqJOABT3beLyEU45yX5-34XIMeIHVeHi1CeSo3i3ufzp86VRH"
    private let endpoint = "https://fcm.googleapis.com/fcm/send"

    /// 相手にPush通知を送る
    func sendPushNotification(friendUid token: String, userId: String, title: String, body: String, completion: @escaping () -> Void) {
        print("通知--------------------------")
        let serverKey = FCM_serverKey
        guard let url = URL(string: endpoint) else { return }
        let paramString: [String: Any] = ["to": token,
                                          "notification": ["title": title, "body": body],
                                          "data": ["userId": userId]]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: paramString, options: [.prettyPrinted])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("key=\(serverKey)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            print("task--------------------------")
            if let error = error {
                print("Error sending push notification: \(error.localizedDescription)")
            } else {
                if let jsonData = data {
                    do {
                        if let jsonDataDict = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject] {
                            print("Received data: \(jsonDataDict)")
                        }
                    } catch {
                        print("Error parsing JSON response: \(error)")
                    }
                }
            }
            // Push 通知の送信が完了した後に completion() を呼び出す
            completion()
        }
        task.resume()
    }
}

