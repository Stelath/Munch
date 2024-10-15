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
        isMapLoaded = false
        geocoder.geocodeAddressString(address) { [weak self] placemarks, error in
            guard let self = self else { return }
            if let error = error {
                print("Geocoding error: \(error.localizedDescription)")
            } else if let location = placemarks?.first?.location {
                let coordinate = location.coordinate
                self.coordinate = coordinate
                self.region = MKCoordinateRegion(
                    center: coordinate,
                    latitudinalMeters: 1000,
                    longitudinalMeters: 1000
                )
            }
            self.isMapLoaded = true
        }
    }
}
