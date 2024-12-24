//
//  AuthenticationViewModel.swift
//  Munch
//
//  Created by Mac Howe on 10/23/24.
//


import SwiftUI
import AuthenticationServices
//import CryptoKit
import KeychainAccess

class AuthenticationViewModel: NSObject, ObservableObject {
    @Published var user: User?
    @Published var errorMessage: String?
    @Published var isLoading = false

    private let keychain = Keychain(service: "com.stelath.Munch")
    private let kUserIdKey = "userId"       // Apple user ID
    private let kUserNameKey = "userName"
    private let kAppTokenKey = "sessionToken"  // Our server's token
    
    
    @MainActor
    func signInWithApple() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName]

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    // TODO: Change should not remove from keychain because cant get name back. Should mark as signed out or make backend api give user id and name back
    @MainActor
    func signOut() {
        user = nil
        try? keychain.remove(kUserIdKey)
        try? keychain.remove(kUserNameKey)
        try? keychain.remove(kAppTokenKey)
    }

    @MainActor
    func restoreUserSession() {
        // only restoreing userId + userName
        // Later ping your server with the token to see if the session is still valid
        if let savedName = keychain[kUserNameKey],
           let savedId = keychain[kUserIdKey] {
            
            //  local user from stored info
            let restoredUser = User(id: savedId, name: savedName)
            self.user = restoredUser
        }
        
        // If you need the session token
        if let sessionToken = keychain[kAppTokenKey] {
            print("DEBUG: We have a session token: \(sessionToken)")
            // Optionally set this in a global or environment for subsequent requests
        }
    }
}

// MARK: - ASAuthorizationControllerDelegate
extension AuthenticationViewModel: ASAuthorizationControllerDelegate {
    nonisolated func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        Task { @MainActor in
            guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else {
                self.errorMessage = AuthenticationError.invalidCredential.localizedDescription
                return
            }

            self.isLoading = true

            do {
                let userId = credential.user
                var userName : String
                
                if let fullName = credential.fullName,
                   !fullName.givenName.isNilOrEmpty,
                   !fullName.familyName.isNilOrEmpty {
                    userName = [fullName.givenName, fullName.familyName]
                        .compactMap { $0 }
                        .joined(separator: " ")
                    // Store userName in Keychain
                    keychain["userName"] = userName
                } else if let storedUserName = keychain["userName"] {
                    userName = storedUserName
                } else {
                    userName = "Unknown"
                }
                
                print("user", userName)

                if let identityToken = credential.identityToken,
                   let tokenString = String(data: identityToken, encoding: .utf8) {
                    let authResponse = try await AuthService.authenticateWithApple(
                        userId: userId,
                        identityToken: tokenString,
                        name: userName
                    )
                    
                    // The server returns { user, token }. We'll store it.
                    keychain[kUserIdKey] = authResponse.user.id  // This might be the same or different from Apple userId
                    keychain[kUserNameKey] = authResponse.user.name
                    keychain[kAppTokenKey] = authResponse.token
                    
                    // Update local user
                    user = authResponse.user

                } else {
                    self.errorMessage = "Failed to retrieve identity token."
                }            } catch {
                self.errorMessage = error.localizedDescription
            }

            self.isLoading = false
        }
    }

    nonisolated func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithError error: Error
    ) {
        Task { @MainActor in
            self.errorMessage = error.localizedDescription
            self.isLoading = false
        }
    }
}

// MARK: - ASAuthorizationControllerPresentationContextProviding
extension AuthenticationViewModel: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow } ?? UIWindow()
    }
}

extension Optional where Wrapped == String {
    var isNilOrEmpty: Bool {
        return self?.isEmpty ?? true
    }
}
