import SwiftUI
import CoreLocation

extension Location {
    /// 位置情報から住所を抽出
    func toAddress(completion: @escaping (String?) -> Void) {
        let geocoder = CLGeocoder()
        var formattedAddress: String?

        // Convert Location struct to CLLocationCoordinate2D
        let coordinate = CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)

        // Reverse geocode the location to get address information
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)

        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            guard error == nil else {
                print("Reverse geocode failed with error: \(error!.localizedDescription)")
                completion(nil)
                return
            }

            if let placemark = placemarks?.first {
                // Format the address using city and locality information
                var addressComponents = [String]()

                if let city = placemark.locality {
                    addressComponents.append(city)
                }
                if let locality = placemark.subLocality {
                    addressComponents.append(locality)
                }

                formattedAddress = addressComponents.joined(separator: "")
                completion(formattedAddress)
            } else {
                print("No placemarks found.")
                completion(nil)
            }
        }
    }
}
