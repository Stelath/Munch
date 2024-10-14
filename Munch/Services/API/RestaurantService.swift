//
//  RestaurantService.swift
//  Munch
//
//  Created by Mac Howe on 10/14/24.
//
//
//import Foundation
//import Combine

//class RestaurantService {
//    func fetchRestaurants(circleId: String) -> AnyPublisher<[Restaurant], Error> {
//        let endpoint = Endpoint.fetchRestaurants(circleId: circleId)
//        return APIClient.shared.request(endpoint)
//    }
//    
//    func submitVote(circleId: String, restaurantId: String, vote: Vote) -> AnyPublisher<Void, Error> {
//        let endpoint = Endpoint.submitVote(circleId: circleId, restaurantId: restaurantId, vote: vote)
//        return APIClient.shared.request(endpoint)
//            .map { _ in () }
//            .eraseToAnyPublisher()
//    }
//
//    func getVotingResults(circleId: String) -> AnyPublisher<[RestaurantVoteResult], Error> {
//        let endpoint = Endpoint.getVotingResults(circleId: circleId)
//        return APIClient.shared.request(endpoint)
//    }
//}
