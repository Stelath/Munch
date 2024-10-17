//
//  CircleService.swift
//  Munch
//
//  Created by Mac Howe on 10/14/24.
//


import Foundation


class CircleService {
    func createCircle(name: String, location: String) async throws -> (id: String, code: String) {
        let endpoint = Endpoint.createCircle(name: name, location: location)
        let response = try await APIClient.shared.request(endpoint, responseType: CreateCircleResponse.self)
        return (response.id, response.code)
    }

    func joinCircle(circleId: String, userID: String, userName: String) async throws {
        let endpoint = Endpoint.joinCircle(circleId: circleId, userID: userID, userName: userName)
        let response = try await APIClient.shared.request(endpoint, responseType: EmptyResponse.self)
        print(response)
    }

    func getCircle(id: String) async throws -> Circle {
        let endpoint = Endpoint.getCircle(id: id)
        return try await APIClient.shared.request(endpoint, responseType: Circle.self)
    }

    func fetchCode(code: String) async throws -> Code {
        let endpoint = Endpoint.fetchCode(code: code)
        return try await APIClient.shared.request(endpoint, responseType: Code.self)
    }
}

// Response models
struct CreateCircleResponse: Decodable {
    let message: String
    let id: String
    let code: String
}
