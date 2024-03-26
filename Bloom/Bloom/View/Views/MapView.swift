//
//  MapView.swift
//  Bloom
//
//  Created by トム・クルーズ on 2024/03/26.
//

import SwiftUI
import MapKit

struct MapView: View {
    @ObservedObject var locationManager = LocationManager.shared

    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194), // San Francisco coordinates as default
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )

    var body: some View {
        Map(coordinateRegion: .constant(region), interactionModes: .all, showsUserLocation: true, userTrackingMode: .constant(.follow))
            .onAppear {
                // Get the current location when the view appears
                locationManager.getCurrentLocation { location in
                    guard let location = location else { return }
                    region.center = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
                }
            }
            .onReceive(locationManager.$currentLocation) { location in
                guard let location = location else { return }
                region.center = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            }
    }
}

#Preview {
    MapView()
}
