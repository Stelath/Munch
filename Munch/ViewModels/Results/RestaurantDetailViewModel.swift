//
//  RestaurantDetailViewModel.swift
//  Munch
//
//  Created by Mac Howe on 10/15/24.
//
import Foundation
import Combine
import CoreLocation
import MapKit

class RestaurantDetailViewModel: ObservableObject {
    @Published var coordinate: CLLocationCoordinate2D?
    @Published var region: MKCoordinateRegion = MKCoordinateRegion()
    @Published var isMapLoaded: Bool = false

    private let geocoder = CLGeocoder()

    func fetchCoordinate(for address: String) {
        Task {
            await MainActor.run {
                self.isMapLoaded = false
            }
            do {
                let placemarks = try await geocoder.geocodeAddressString(address)
                if let location = placemarks.first?.location {
                    let coordinate = location.coordinate
                    await MainActor.run {
                        self.coordinate = coordinate
                        self.region = MKCoordinateRegion(
                            center: coordinate,
                            latitudinalMeters: 1000,
                            longitudinalMeters: 1000
                        )
                    }
                } else {
                    print("No location found for address: \(address)")
                }
            } catch {
                print("Geocoding error: \(error.localizedDescription)")
            }
            await MainActor.run {
                self.isMapLoaded = true
            }
        }
    }
}
