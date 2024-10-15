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
    private var circleId: String?
    
    init(circleId: String) {
        self.circleId = circleId
        Task {
            fetchResults()
        }
    }
    
    func fetchResults() {
        Task {
            guard let circleId = circleId else { return }
            isLoading = true
            do {
                let results = try await restaurantService.getVotingResults(circleId: circleId)
                self.restaurantResults = results.sorted { $0.score > $1.score }
            } catch {
                self.errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }
    
    func startListeningForUpdates() {
            guard let url = URL(string: "https://api.yourapp.com/circles/\(circleId)/results/events") else { return }
            let sseService = SSEService()
            sseService.startListening(url: url) { [weak self] eventString in //Variable 'self' was written to, but never read
                // Parse eventString to update results
                // Update self?.restaurantResults accordingly
            }
        }
}
