//
//  RestaurantService.swift
//  Munch
//
//  Created by Mac Howe on 10/14/24.
//
//
import Foundation


class RestaurantService {
    func fetchRestaurants(circleId: String) async throws -> [Restaurant] {
        let endpoint = Endpoint.fetchRestaurants(circleId: circleId)
        return try await APIClient.shared.request(endpoint)
    }

    func submitVote(circleId: String, restaurantId: String, voteType: VoteType) async throws {
        let endpoint = Endpoint.submitVote(circleId: circleId, restaurantId: restaurantId, voteType: voteType)
        _ = try await APIClient.shared.request(endpoint) as EmptyResponse
    }

    func getVotingResults(circleId: String) async throws -> [RestaurantVoteResult] {
        let endpoint = Endpoint.getVotingResults(circleId: circleId)
        return try await APIClient.shared.request(endpoint)
    }
}

// Helper for endpoints that return no data
struct EmptyResponse: Decodable {}
