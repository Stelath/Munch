//
//  SwipeViewModel.swift
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
    @Published private(set) var yesRestaurants: [Restaurant] = [] // TODO: just hold id later, may not need to hold bc will fetch from backend and send results as we go
    @Published private(set) var noRestaurants: [Restaurant] = []
    @Published var isLoading: Bool = false
    
    let locationService = LocationService()
    private let restaurantService = RestaurantService()
    private var cancellables = Set<AnyCancellable>()
    private var circleId: String?
    private var currentIndex: Int = 0
    
    init() {
        locationService.requestLocationPermission()
        observeLocationUpdates()
        print("init") // DEBUG
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
            .first()
        //            .removeDuplicates(by: { (loc1, loc2) in
        //                    // Prevents multiple fetches for the same location
        //                    loc1.coordinate.latitude == loc2.coordinate.latitude &&
        //                    loc1.coordinate.longitude == loc2.coordinate.longitude
        //                })
        //                .debounce(for: .seconds(2), scheduler: DispatchQueue.main)  // Throttle quick successive updates
            .sink { [weak self] location in
                self?.fetchRestaurants(near: location)
            }
            .store(in: &cancellables)
    }
    func fetchRestaurants() {
        guard let circleId = circleId else { return }
        isLoading = true
        
        restaurantService.fetchRestaurants(circleId: circleId)
            .sink(receiveCompletion: { completion in
                self.isLoading = false
                if case let .failure(error) = completion {
                    // Handle error
                }
            }, receiveValue: { restaurants in
                self.restaurants = restaurants
                self.updateRestaurantViewModels()
            })
            .store(in: &cancellables)
        }
//    func fetchRestaurants(near location: CLLocation) {
//        isLoading = true
//        Task { [weak self] in
//            guard let self else { return }
//            do {
//                let fetchedRestaurants = try await self.restaurantService.fetchRestaurants(near: location.coordinate)
//                await MainActor.run {
//                    self.restaurants = fetchedRestaurants
//                    self.updateRestaurantViewModels()
//                    self.isLoading = false
//                }
//            } catch {
//                await MainActor.run {
//                    print("Failed to fetch restaurants: \(error.localizedDescription)")
//                    self.isLoading = false
//                }
//            }
//        }
//    }

    private func updateRestaurantViewModels() {
        print("Updating restaurant view models") //DEBUG
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
