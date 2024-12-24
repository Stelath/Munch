//
//  AuthService.swift
//  Munch
//
//  Created by Mac Howe on 10/23/24.
//

import Foundation

struct AuthResponse: Decodable {
    let user: User
    let token: String
}

class AuthService {
    @discardableResult
    static func authenticateWithApple(userId: String,identityToken: String, name: String) async throws -> AuthResponse {
        let endpoint = Endpoint.authenticateWithApple(userId: userId,
                                                      identityToken: identityToken,
                                                      name: name)
        // Expect AuthResponse from backend
        let response: AuthResponse = try await APIClient.shared.request(endpoint)
        return response
    }
}

