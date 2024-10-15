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

    private let circleService = CircleService()
    private let sseService = SSEService()
    private var cancellables = Set<AnyCancellable>()
    private var circleId: String? // Assume this is set from context

    private var cancellables = Set<AnyCancellable>()

    init() {
        fetchResults()
    }

    func fetchResults() {
            guard let circleId = circleId else { return }
            isLoading = true

            circleService.getVotingResults(circleId: circleId)
                .sink(receiveCompletion: { completion in
                    self.isLoading = false
                    if case let .failure(error) = completion {
                        // Handle error
                    }
                }, receiveValue: { results in
                    self.restaurantResults = results.sorted { $0.score > $1.score }
                })
                .store(in: &cancellables)
        }

        func startListeningForUpdates() {
            guard let circleId = circleId else { return }
            sseService.voteUpdates
                .receive(on: DispatchQueue.main)
                .sink { update in
                    // Update `restaurantResults` based on the update
                }
                .store(in: &cancellables)
            sseService.startListening(circleId: circleId)
        }
    }
