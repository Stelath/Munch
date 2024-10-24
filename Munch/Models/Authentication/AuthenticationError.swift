//
//  AuthenticationError.swift
//  Munch
//
//  Created by Mac Howe on 10/23/24.
//

import Foundation

enum AuthenticationError: LocalizedError {
    case invalidCredential
    case networkError
    case serverError(String)
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .invalidCredential:
            return "Invalid authentication credentials"
        case .networkError:
            return "Unable to connect to server"
        case .serverError(let message):
            return message
        case .unknown:
            return "An unknown error occurred"
        }
    }
}
