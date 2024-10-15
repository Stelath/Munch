//
//  RestaurantService.swift
//  Munch
//
//  Created by Mac Howe on 10/14/24.
//
//
import Foundation


class RestaurantService {
    func fetchRestaurants(circleId: UUID) async throws -> [Restaurant] {
        let endpoint = Endpoint.fetchRestaurants(circleId: circleId)
        return try await APIClient.shared.request(endpoint, responseType: [Restaurant].self)
    }

    func submitVote(circleId: UUID, restaurantId: UUID, voteType: VoteType) async throws {
        let endpoint = Endpoint.submitVote(circleId: circleId, restaurantId: restaurantId, voteType: voteType)
        _ = try await APIClient.shared.request(endpoint, responseType: EmptyResponse.self)
    }

    func getVotingResults(circleId: UUID) async throws -> [RestaurantVoteResult] {
        let endpoint = Endpoint.getVotingResults(circleId: circleId)
        return try await APIClient.shared.request(endpoint, responseType: [RestaurantVoteResult].self)
    }
}

// Helper for endpoints that return no data
struct EmptyResponse: Decodable {}
