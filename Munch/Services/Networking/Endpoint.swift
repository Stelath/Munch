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
    
    // REMOVE STARTED Boolean
    static func createCircle(name: String, location: String, started: Bool = false) -> Endpoint {
        return Endpoint(
            path: "/circles",
            method: .POST,
            headers: ["Content-Type": "application/json"],
            body: ["name": name, "location": location, "started": started]
        )
    }
    
    static func joinCircle(circleId: String, userID: String, userName: String) -> Endpoint {
        return Endpoint(
            path: "/circles/\(circleId)/join",
            method: .POST,
            headers: ["Content-Type": "application/json"],
            body: ["id": userID, "name": userName]
        )
    }
    
    static func getCircle(id: String) -> Endpoint {
        return Endpoint(
            path: "/circles/\(id)",
            method: .GET,
            headers: nil,
            body: nil
        )
    }
    
    // Change name to more descriptive one: ie. getCircleIDByCode
    static func fetchCode(code: String) -> Endpoint {
        return Endpoint(
            path: "/codes/\(code)",
            method: .GET,
            headers: nil,
            body: nil
        )
    }
    
    static func startCircle(circleId: String) -> Endpoint {
        return Endpoint(
            path: "/circles/\(circleId)/start",
            method: .POST,
            headers: nil,
            body: nil
        )
    }

    static func fetchRestaurants(circleId: String) -> Endpoint {
        return Endpoint(
            path: "/circles/\(circleId)/restaurants",
            method: .GET,
            headers: nil,
            body: nil
        )
    }

    static func submitVote(circleId: String, restaurantId: String, voteType: VoteType) -> Endpoint {
        return Endpoint(
            path: "/circles/\(circleId)/restaurants/\(restaurantId)/vote",
            method: .POST,
            headers: ["Content-Type": "application/json"],
            body: ["vote": voteType.rawValue]
        )
    }

    static func getVotingResults(circleId: String) -> Endpoint {
        return Endpoint(
            path: "/circles/\(circleId)/results",
            method: .GET,
            headers: nil,
            body: nil
        )
    }
}
