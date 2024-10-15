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

    static func createCircle(userId: String, name: String, location: String) -> Endpoint {
        return Endpoint(
            path: "/circles",
            method: .POST,
            headers: ["Content-Type": "application/json"],
            body: ["userId": userId, "name": name, "location": location]
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

    static func getCircle(circleId: String) -> Endpoint {
        return Endpoint(
            path: "/circles/\(circleId)",
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

    static func submitVote(circleId: String, restaurantId: String, vote: String) -> Endpoint {
        return Endpoint(
            path: "/circles/\(circleId)/restaurants/\(restaurantId)/vote",
            method: .POST,
            headers: ["Content-Type": "application/json"],
            body: ["vote": vote]
        )
    }
}
