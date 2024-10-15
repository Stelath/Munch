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

@MainActor
class SwipeViewModel: ObservableObject {
    @Published private(set) var restaurants: [Restaurant] = []
    @Published private(set) var restaurantViewModels: [RestaurantViewModel] = []
    @Published var isLoading: Bool = false

    private let restaurantService = RestaurantService()
    private var circleId: String
    private var currentIndex: Int = 0

    init(circleId: String) {
        self.circleId = circleId
        Task {
            await fetchRestaurants()
        }
    }

    var isAllRestaurantsSwiped: Bool {
        return currentIndex < 0
    }

    var currentRestaurantViewModel: RestaurantViewModel? {
        guard currentIndex >= 0 && currentIndex < restaurantViewModels.count else { return nil }
        return restaurantViewModels[currentIndex]
    }

    func fetchRestaurants() async {
        isLoading = true
        do {
            let fetchedRestaurants = try await restaurantService.fetchRestaurants(circleId: circleId)
            self.restaurants = fetchedRestaurants
            self.updateRestaurantViewModels()
        } catch {
            print("Failed to fetch restaurants: \(error.localizedDescription)")
        }
        isLoading = false
    }

    private func updateRestaurantViewModels() {
        self.restaurantViewModels = restaurants.map { RestaurantViewModel(restaurant: $0) }
        self.currentIndex = self.restaurantViewModels.count - 1
    }

    func handleSwipe(direction: SwipeDirection) {
        guard currentIndex >= 0 else { return }

        let restaurantViewModel = restaurantViewModels[currentIndex]
        Task {
            do {
                let voteType: VoteType = (direction == .right) ? .like : .dislike
                try await restaurantService.submitVote(
                    circleId: circleId,
                    restaurantId: restaurantViewModel.restaurant.id,
                    voteType: voteType
                )
            } catch {
                print("Failed to submit vote: \(error.localizedDescription)")
            }
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
