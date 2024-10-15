//
//  CreateCircleViewModel.swift
//  Munch
//
//  Created by Alexander Korte on 6/16/24.
//

import Foundation
import Combine

class CreateCircleViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var location: String = ""
    @Published var generatedCode: String?
    @Published var joinedUsers: [User] = []
    @Published var canStartCircle: Bool = false
    @Published var errorMessage: String?

    private let circleService = CircleService()
    private let sseService = SSEService()
    private var circleId: String?

    func createCircle(userId: String) {
        Task {
            do {
                let circle = try await circleService.createCircle(userId: userId, name: name, location: location)
                self.generatedCode = circle.code
                self.circleId = circle.id
                self.joinedUsers = circle.users
                startListeningForUpdates()
            } catch {
                self.errorMessage = error.localizedDescription
            }
        }
    }

    func startCircle() {
        Task {
            do {
                guard let circleId = circleId else { return }
                let circle = try await circleService.startCircle(circleId: circleId)
                self.canStartCircle = circle.started
                // Navigate to the next screen if needed
            } catch {
                self.errorMessage = error.localizedDescription
            }
        }
    }

    private func startListeningForUpdates() {
        guard let circleId = circleId,
              let url = URL(string: "https://api.yourapp.com/circles/\(circleId)/events") else { return }
        sseService.startListening(url: url) { [weak self] eventString in //Warnning: Variable 'self' was written to, but never read
            // Parse eventString to get updated users
            // Update self?.joinedUsers accordingly
        }
    }
}
