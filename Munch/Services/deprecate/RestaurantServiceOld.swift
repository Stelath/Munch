//
//  RestaurantService.swift
//  Munch
//
//  Created by Mac Howe on 10/13/24.
//

import Foundation
import MapKit

class RestaurantService {
    func fetchRestaurants(near location: CLLocationCoordinate2D) async throws -> [Restaurant] {
        print("Fetching restaurants near \(location)") // DEBUG
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "restaurant"
        request.region = MKCoordinateRegion(center: location, latitudinalMeters: 5000, longitudinalMeters: 5000)

        let search = MKLocalSearch(request: request)
        let response: MKLocalSearch.Response
        do {
            response = try await search.start()
        } catch {
            throw error
        }

        let restaurants = response.mapItems.map { item in
            Restaurant(
                id: UUID(),
                name: item.name ?? "Unknown",
                address: item.placemark.title ?? "No Address",
                images: [""],
                coordinate: item.placemark.coordinate,
                mapItem: item
            )
        }

        return restaurants
    }
}
