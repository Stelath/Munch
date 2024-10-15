//
//  CircleService.swift
//  Munch
//
//  Created by Mac Howe on 10/14/24.
//


import Foundation

class CircleService {
    func createCircle(userId: String, name: String, location: String) async throws -> Circle {
        let endpoint = Endpoint.createCircle(userId: userId, name: name, location: location)
        return try await APIClient.shared.request(endpoint, responseType: Circle.self)
    }

    func joinCircle(code: String, userName: String) async throws -> Circle {
        let endpoint = Endpoint.joinCircle(code: code, userName: userName)
        return try await APIClient.shared.request(endpoint, responseType: Circle.self)
    }

    func getCircle(circleId: String) async throws -> Circle {
        let endpoint = Endpoint.getCircle(circleId: circleId)
        return try await APIClient.shared.request(endpoint, responseType: Circle.self)
    }

    func startCircle(circleId: String) async throws -> Circle {
        let endpoint = Endpoint.startCircle(circleId: circleId)
        return try await APIClient.shared.request(endpoint, responseType: Circle.self)
    }
}
