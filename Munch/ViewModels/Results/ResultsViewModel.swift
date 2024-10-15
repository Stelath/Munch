//
//  ResultsViewModel.swift
//  Munch
//
//  Created by Mac Howe on 10/14/24.
//

import Foundation
import Combine
import MapKit

class ResultsViewModel: ObservableObject {
    @Published var restaurantResults: [RestaurantVoteResult] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()

    init() {
        fetchResults()
    }

    func fetchResults() {
        isLoading = true
        errorMessage = nil

        // Simulate fetching data
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            let sampleResults = [
                RestaurantVoteResult(
                    restaurant: Restaurant(
                        id: UUID(),
                        name: "Sushi Place",
                        address: "123 Main St",
                        images: ["https://source.unsplash.com/featured/?sushi"],
                        coordinate: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
                        mapItem: MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)))
                    ),
                    likes: 10,
                    dislikes: 2
                ),
                RestaurantVoteResult(
                    restaurant: Restaurant(
                        id: UUID(),
                        name: "Pizza Corner",
                        address: "456 Elm St",
                        images: ["https://source.unsplash.com/featured/?pizza"],
                        coordinate: CLLocationCoordinate2D(latitude: 37.8044, longitude: -122.2712),
                        mapItem: MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 37.8044, longitude: -122.2712)))
                    ),
                    likes: 8,
                    dislikes: 1
                ),
                RestaurantVoteResult(
                    restaurant: Restaurant(
                        id: UUID(),
                        name: "Burger Joint",
                        address: "789 Oak St",
                        images: ["https://source.unsplash.com/featured/?burger"],
                        coordinate: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
                        mapItem: MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)))
                    ),
                    likes: 5,
                    dislikes: 0
                )
            ]

            DispatchQueue.main.async {
                self.isLoading = false
                self.restaurantResults = sampleResults.sorted { $0.score > $1.score }
            }
        }
    }

    // Placeholder for SSE updates
    func startListeningForUpdates() {
        // Future SSE implementation to update `restaurantResults`
    }
}
