//
//  RestaurantService.swift
//  Munch
//
//  Created by Mac Howe on 10/14/24.
//
//
import Foundation
import Combine

import Foundation

class RestaurantService {
    func fetchRestaurants(circleId: String) async throws -> [Restaurant] {
        let endpoint = Endpoint.fetchRestaurants(circleId: circleId)
        return try await APIClient.shared.request(endpoint, responseType: [Restaurant].self)
    }

    func submitVote(circleId: String, restaurantId: String, voteType: VoteType) async throws {
        let endpoint = Endpoint.submitVote(circleId: circleId, restaurantId: restaurantId, voteType: voteType)
        _ = try await APIClient.shared.request(endpoint, responseType: EmptyResponse.self)
    }

    func getVotingResults(circleId: String) async throws -> [RestaurantVoteResult] {
        let endpoint = Endpoint.getVotingResults(circleId: circleId)
        return try await APIClient.shared.request(endpoint, responseType: [RestaurantVoteResult].self)
    }
}

// Helper for endpoints that return no data
struct EmptyResponse: Decodable {}
