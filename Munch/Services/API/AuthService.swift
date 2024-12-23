//
//  AuthService.swift
//  Munch
//
//  Created by Mac Howe on 10/23/24.
//

import Foundation

class AuthService {
    static func authenticateWithApple(userId: String, identityToken: String, name: String) async throws {
        let endpoint = Endpoint.authenticateWithApple(userId: userId, identityToken: identityToken, name: name)
        _ = try await APIClient.shared.request(endpoint) as EmptyResponse
    }
}
