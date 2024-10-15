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
    private let sseService = SSEService()
    let circleId: UUID
    
    init(circleId: UUID) {
        self.circleId = circleId
        Task {
            await fetchResults()
            startListeningForUpdates()
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
    
    func startListeningForUpdates() {
        guard let url = URL(string: "https://api.yourapp.com/circles/\(circleId.uuidString)/results/events") else { return }
        sseService.startListening(url: url) { [weak self] eventName, eventData in
            guard let self = self else { return }
            if eventName == "vote_updated", let data = eventData?.data(using: .utf8) {
                do {
                    let updatedResult = try JSONDecoder().decode(RestaurantVoteResult.self, from: data)
                    DispatchQueue.main.async {
                        if let index = self.restaurantResults.firstIndex(where: { $0.restaurant.id == updatedResult.restaurant.id }) {
                            self.restaurantResults[index] = updatedResult
                            self.restaurantResults.sort { $0.score > $1.score }
                        }
                    }
                } catch {
                    print("Failed to decode vote_updated event: \(error.localizedDescription)")
                }
            }
        }
    }

    func stopListeningForUpdates() {
        sseService.stopListening()
    }
}
