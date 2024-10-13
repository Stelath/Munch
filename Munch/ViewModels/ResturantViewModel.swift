//
//  ResturantViewModel.swift
//  Munch
//
//  Created by Alexander Korte on 6/17/24.
//

import Foundation
import Combine
import MapKit

public enum SwipeDirection {
    case left
    case right
}

class RestaurantViewModel: ObservableObject {
    @Published private(set) var restaurants: [Restaurant] = []
    @Published private(set) var cardViewModels: [CardViewModel] = []
    @Published private(set) var yesRestaurants: [Card] = []
    @Published private(set) var noRestaurants: [Card] = []
    @Published var isLoading: Bool = false

    let locationService = LocationService()
    private let restaurantService = RestaurantService()
    private var cancellables = Set<AnyCancellable>()
    private var currentCardIndex: Int = 0

    init() {
        observeLocationUpdates()
        locationService.requestLocationPermission()
    }

    var isAllRestaurantsSwiped: Bool {
        return restaurants.count == (yesRestaurants.count + noRestaurants.count)
    }

    var currentCardViewModel: CardViewModel? {
        guard currentCardIndex >= 0 && currentCardIndex < cardViewModels.count else { return nil }
        return cardViewModels[currentCardIndex]
    }

    private func observeLocationUpdates() {
        locationService.$currentLocation
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] location in
                self?.fetchRestaurants(near: location)
            }
            .store(in: &cancellables)
    }

    func fetchRestaurants(near location: CLLocation) {
        isLoading = true
        Task { [weak self] in
            guard let self = self else { return }
            do {
                let fetchedRestaurants = try await self.restaurantService.fetchRestaurants(near: location.coordinate)
                await MainActor.run {
                    self.restaurants = fetchedRestaurants
                    self.updateCards()
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    print("Failed to fetch restaurants: \(error.localizedDescription)")
                    self.isLoading = false
                }
            }
        }
    }

    private func updateCards() {
        self.cardViewModels = restaurants.map { restaurant in
            let card = Card(
                name: restaurant.name,
                about: "",
                coordinate: restaurant.coordinate,
                mapItem: restaurant.mapItem
            )
            return CardViewModel(card: card)
        }
        self.currentCardIndex = self.cardViewModels.count - 1
    }

    func handleSwipe(direction: SwipeDirection) {
        guard currentCardIndex >= 0 else { return }

        let cardViewModel = cardViewModels[currentCardIndex]

        if direction == .left {
            noRestaurants.append(cardViewModel.card)
        } else {
            yesRestaurants.append(cardViewModel.card)
        }

        currentCardIndex -= 1
    }

    func performSwipe(direction: SwipeDirection) {
        guard let cardViewModel = currentCardViewModel else { return }
        cardViewModel.performSwipe(direction: direction) { [weak self] in
            self?.handleSwipe(direction: direction)
        }
    }
}
//
//extension RestaurantViewModel: CLLocationManagerDelegate {
//    // Grab location permissions from users
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        if status == .authorizedWhenInUse || status == .authorizedAlways {
//            locationManager.startUpdatingLocation()
//        } else {
//            print("Location permission denied")
//        }
//    }
//    
//    // Once we grab the restaurants stop using the users current location
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if let location = locations.first {
//            let tempLocation = CLLocation(latitude:34.681951192984215, longitude:-82.83710411475863)
//            fetchRestaurants(near: tempLocation)
//            locationManager.stopUpdatingLocation()
//        }
//    }
//    
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print("Failed to get user location: \(error.localizedDescription)")
//    }
//}
