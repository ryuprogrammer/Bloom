import Foundation
import UIKit
import Vision

// ViewModel
struct FaceDetectionViewModel {
    // 顔を検出して黒く塗りつぶすメソッド
    public func detectAndDrawFaces(imageData: Data, completion: @escaping (UIImage?) -> Void) {
        guard let image = UIImage(data: imageData) else {
            completion(nil)
            return
        }

        guard let ciImage = CIImage(image: image) else {
            completion(nil)
            return
        }

        // 顔ランドマークの検出リクエスト
        let faceDetectionRequest = VNDetectFaceLandmarksRequest { (request, error) in
            if let error = error {
                print("顔検出エラー: \(error.localizedDescription)")
                completion(nil)
                return
            }

            guard let observations = request.results as? [VNFaceObservation] else {
                // 顔が検出されなかった場合は、元の画像を返す
                DispatchQueue.main.async {
                    completion(image)
                }
                return
            }

            // CGContextの作成
            UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
            guard let cgContext = UIGraphicsGetCurrentContext() else {
                completion(nil)
                return
            }
            defer {
                UIGraphicsEndImageContext()
            }
            // 元の画像の描画
            image.draw(at: .zero)

            // 検出された顔に黒いオーバーレイを描画
            for observation in observations {
                if let landmarks = observation.landmarks {
                    self.drawFaceContours(landmarks: landmarks, in: cgContext, imageSize: image.size)
                }
            }

            // CGContextから修正された画像を取得
            guard let modifiedImage = UIGraphicsGetImageFromCurrentImageContext() else {
                completion(nil)
                return
            }

            // 修正された画像をUIImageに変換
            DispatchQueue.main.async {
                completion(modifiedImage)
            }
        }

        let faceDetectionHandler = VNImageRequestHandler(ciImage: ciImage, options: [:])
        do {
            try faceDetectionHandler.perform([faceDetectionRequest])
        } catch {
            print("顔検出の実行に失敗しました: \(error.localizedDescription)")
            completion(nil)
        }
    }

    private func drawFaceContours(landmarks: VNFaceLandmarks2D, in context: CGContext, imageSize: CGSize) {
        // ランドマークの座標を取得
        let faceContourPoints = landmarks.faceContour?.pointsInImage(imageSize: imageSize) ?? []

        // 座標が2つ以上ないと描画できない
        guard faceContourPoints.count > 1 else {
            return
        }

        // 座標系の変換（y軸の反転と原点の移動）
        context.translateBy(x: 0, y: imageSize.height)
        context.scaleBy(x: 1, y: -1)

        // ランドマークの輪郭を描画
        context.setFillColor(UIColor.black.cgColor)
        context.setStrokeColor(UIColor.black.cgColor)
        context.setLineWidth(2.0)
        context.addLines(between: faceContourPoints)
        context.closePath()
        context.drawPath(using: .fillStroke)

        // 上部を丸くするために輪郭を追加
        if let firstPoint = faceContourPoints.first, let lastPoint = faceContourPoints.last {
            let radius: CGFloat = 20.0
            let startAngle: CGFloat = 0
            let endAngle: CGFloat = CGFloat.pi
            let center = CGPoint(x: (firstPoint.x + lastPoint.x) / 2.0, y: (firstPoint.y + lastPoint.y) / 2.0)
            context.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            context.drawPath(using: .fillStroke)
        }
    }
}

