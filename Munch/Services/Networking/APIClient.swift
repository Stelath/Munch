//
//  APIClient.swift
//  Munch
//
//  Created by Mac Howe on 10/14/24.
//

import Foundation

class APIClient {
    static let shared = APIClient()
    private let session: URLSession = .shared
    private let baseURL = URL(string: "http://localhost:3000")!

    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        var request = URLRequest(url: baseURL.appendingPathComponent(endpoint.path))
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.headers

        if let body = endpoint.body {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        }

        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        switch httpResponse.statusCode {
        case 200...299:
            return try JSONDecoder().decode(T.self, from: data)
        default:
            let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data)
            let errorMessage = errorResponse?.message ?? "An unknown error occurred."
            throw APIError.serverError(errorMessage)
        }
    }
}

// Define error types
struct ErrorResponse: Decodable {
    let message: String
}

enum APIError: Error {
    case invalidResponse
    case serverError(String)
}
