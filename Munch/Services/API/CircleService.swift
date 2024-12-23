//
//  CircleService.swift
//  Munch
//
//  Created by Mac Howe on 10/14/24.
//


import Foundation

enum CircleServiceError: Error {
    case invalidResponse
    case serverError(String)
}

class CircleService {
    static let shared = CircleService()
    private init() {}
    
    func createCircle(name: String, location: String) async throws -> (id: String, code: String) {
        let endpoint = Endpoint.createCircle(name: name, location: location)
        let response: CreateCircleResponse = try await APIClient.shared.request(endpoint)
        return (response.id, response.code)
    }

    func joinCircle(circleId: String, userID: String, userName: String) async throws {
        let endpoint = Endpoint.joinCircle(circleId: circleId, userID: userID, userName: userName)
        _ = try await APIClient.shared.request(endpoint) as EmptyResponse
    }

    func getCircle(id: String) async throws -> Circle {
        let endpoint = Endpoint.getCircle(id: id)
        return try await APIClient.shared.request(endpoint)
    }

    func fetchCode(code: String) async throws -> Code {
        let endpoint = Endpoint.fetchCode(code: code)
        return try await APIClient.shared.request(endpoint)
    }
}

// Response models
struct CreateCircleResponse: Decodable {
    let message: String
    let id: String
    let code: String
}
