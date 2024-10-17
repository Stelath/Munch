//
//  APIClient.swift
//  Munch
//
//  Created by Mac Howe on 10/14/24.
//

import Foundation

class APIClient {
    static let shared = APIClient()
    private let session: URLSession
    private let baseURL = URL(string: "http://localhost:3000")! // Update with your backend URL

    private init(session: URLSession = .shared) {
        self.session = session
    }

    func request<T: Decodable>(_ endpoint: Endpoint, responseType: T.Type) async throws -> T {
        var request = URLRequest(url: baseURL.appendingPathComponent(endpoint.path))
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.headers

        if let body = endpoint.body {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        }

        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
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

enum APIError: Error, LocalizedError {
    case serverError(String)

    var errorDescription: String? {
        switch self {
        case .serverError(let message):
            return message
        }
    }
}
