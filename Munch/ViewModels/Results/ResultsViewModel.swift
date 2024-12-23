//
//  ResultsViewModel.swift
//  Munch
//
//  Created by Mac Howe on 10/14/24.
//

import Foundation
import Combine
import MapKit

@MainActor
class ResultsViewModel: ObservableObject {
    @Published var restaurantResults: [RestaurantVoteResult] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let restaurantService = RestaurantService()
    private var cancellables = Set<AnyCancellable>()
    
    let circleId: String
    
    init(circleId: String) {
        self.circleId = circleId
        Task {
            await fetchResults()
        }
    }
    
    func fetchResults() async {
        isLoading = true
        do {
            let results = try await restaurantService.getVotingResults(circleId: circleId)
            self.restaurantResults = results.sorted { $0.score > $1.score }
        } catch {
            self.errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    func subscribeToWebSocketEvents(_ webSocketManager: WebSocketManager) {
        webSocketManager.eventPublisher
            .sink { [weak self] event in
                guard let self = self else { return }
                switch event {
                case .voteUpdated(let updatedResult):
                    // If this update is for our circle's restaurant, update it
                    if let idx = self.restaurantResults.firstIndex(where: {
                        $0.restaurant.id == updatedResult.restaurant.id
                    }) {
                        self.restaurantResults[idx] = updatedResult
                    } else {
                        self.restaurantResults.append(updatedResult)
                    }
                    // Re-sort
                    self.restaurantResults.sort { $0.score > $1.score }
                default:
                    break
                }
            }
            .store(in: &cancellables)
    }
}
