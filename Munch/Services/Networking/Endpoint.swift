//
//  Endpoint.swift
//  Munch
//
//  Created by Mac Howe on 10/14/24.
//

import Foundation

enum HTTPMethod: String {
    case GET
    case POST
    case PATCH
}

struct Endpoint {
    let path: String
    let method: HTTPMethod
    let headers: [String: String]?
    let body: [String: Any]?
    
    static func createCircle(userId: UUID, name: String, location: String) -> Endpoint {
        return Endpoint(
            path: "/circles",
            method: .POST,
            headers: ["Content-Type": "application/json"],
            body: ["userId": userId.uuidString, "name": name, "location": location]
        )
    }

    static func joinCircle(code: String, userName: String) -> Endpoint {
        return Endpoint(
            path: "/circles/join",
            method: .POST,
            headers: ["Content-Type": "application/json"],
            body: ["code": code, "userName": userName]
        )
    }

    static func getCircle(circleId: UUID) -> Endpoint {
        return Endpoint(
            path: "/circles/\(circleId.uuidString)",
            method: .GET,
            headers: nil,
            body: nil
        )
    }
    
    static func startCircle(circleId: UUID) -> Endpoint {
        return Endpoint(
            path: "/circles/\(circleId.uuidString)/start",
            method: .POST,
            headers: nil,
            body: nil
        )
    }

    static func fetchRestaurants(circleId: UUID) -> Endpoint {
        return Endpoint(
            path: "/circles/\(circleId.uuidString)/restaurants",
            method: .GET,
            headers: nil,
            body: nil
        )
    }

    static func submitVote(circleId: UUID, restaurantId: UUID, voteType: VoteType) -> Endpoint {
        return Endpoint(
            path: "/circles/\(circleId.uuidString)/restaurants/\(restaurantId.uuidString)/vote",
            method: .POST,
            headers: ["Content-Type": "application/json"],
            body: ["vote": voteType.rawValue]
        )
    }

    static func getVotingResults(circleId: UUID) -> Endpoint {
        return Endpoint(
            path: "/circles/\(circleId.uuidString)/results",
            method: .GET,
            headers: nil,
            body: nil
        )
    }
}
