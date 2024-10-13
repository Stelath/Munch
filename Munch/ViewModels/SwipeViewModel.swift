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

class SwipeViewModel: ObservableObject {
    @Published private(set) var restaurants: [Restaurant] = []
    @Published private(set) var restaurantViewModels: [RestaurantViewModel] = []
    @Published private(set) var yesRestaurants: [Restaurant] = []
    @Published private(set) var noRestaurants: [Restaurant] = []
    @Published var isLoading: Bool = false

    let locationService = LocationService()
    private let restaurantService = RestaurantService()
    private var cancellables = Set<AnyCancellable>()
    private var currentIndex: Int = 0

    init() {
        observeLocationUpdates()
        locationService.requestLocationPermission()
    }

    var isAllRestaurantsSwiped: Bool {
        return restaurants.count == (yesRestaurants.count + noRestaurants.count)
    }

    var currentRestaurantViewModel: RestaurantViewModel? {
        guard currentIndex >= 0 && currentIndex < restaurantViewModels.count else { return nil }
        return restaurantViewModels[currentIndex]
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
            guard let self else { return }
            do {
                let fetchedRestaurants = try await self.restaurantService.fetchRestaurants(near: location.coordinate)
                await MainActor.run {
                    self.restaurants = fetchedRestaurants
                    self.updateRestaurantViewModels()
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

    private func updateRestaurantViewModels() {
        self.restaurantViewModels = restaurants.map { RestaurantViewModel(restaurant: $0) }
        self.currentIndex = self.restaurantViewModels.count - 1
    }

    func handleSwipe(direction: SwipeDirection) {
        guard currentIndex >= 0 else { return }

        let restaurantViewModel = restaurantViewModels[currentIndex]

        if direction == .left {
            noRestaurants.append(restaurantViewModel.restaurant)
        } else {
            yesRestaurants.append(restaurantViewModel.restaurant)
        }

        currentIndex -= 1
    }

    func performSwipe(direction: SwipeDirection) {
        guard let restaurantViewModel = currentRestaurantViewModel else { return }
        restaurantViewModel.performSwipe(direction: direction) { [weak self] in
            self?.handleSwipe(direction: direction)
        }
    }
}
