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

    @MainActor
    func signInWithApple() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName]

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }

    @MainActor
    func signOut() {
        user = nil
        try? keychain.remove("userId")
        try? keychain.remove("userName")
    }

    @MainActor
    func restoreUserSession() {
        if let userId = keychain["userId"],
           let userName = keychain["userName"] {
            user = User(id: userId, name: userName)
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
                let fullName = credential.fullName
                let userName = [fullName?.givenName, fullName?.familyName]
                    .compactMap { $0 }
                    .joined(separator: " ")

                if let identityToken = credential.identityToken {
                    let tokenString = identityToken.base64EncodedString()
                    try await AuthService.authenticateWithApple(
                        userId: userId,
                        identityToken: tokenString,
                        name: userName
                    )
                } else {
                    self.errorMessage = "Failed to retrieve identity token."
                }
                keychain["userId"] = userId
                keychain["userName"] = userName
                user = User(id: userId, name: userName)
            } catch {
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
