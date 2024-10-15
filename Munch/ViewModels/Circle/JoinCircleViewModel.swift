//
//  JoinCircleViewModel.swift
//  Munch
//
//  Created by Mac Howe on 10/14/24.
//

import Foundation
import Combine

@MainActor
class JoinCircleViewModel: ObservableObject {
    @Published var circleCode: String = ""
    @Published var name: String = ""
    @Published var joinedUsers: [User] = []
    @Published var isLoading: Bool = false
    @Published var isWaitingToStart: Bool = false
    @Published var errorMessage: String?

    private let circleService = CircleService()
    private let sseService = SSEService()
    private var circleId: UUID?


    func joinCircle() {
        Task {
            guard !circleCode.isEmpty else {
                errorMessage = "Circle code cannot be empty."
                return
            }

            isLoading = true
            errorMessage = nil

            do {
                let circle = try await circleService.joinCircle(code: circleCode, userName: name)
                self.circleId = circle.id
                self.joinedUsers = circle.users
                self.isWaitingToStart = true
                startListeningForUpdates()
            } catch {
                self.errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }

    private func startListeningForUpdates() {
        guard let circleId = circleId,
              let url = URL(string: "https://api.yourapp.com/circles/\(circleId)/events") else { return }
        sseService.startListening(url: url) { [weak self] eventString in //Variable 'self' was written to, but never read
            // Parse eventString to get updated users
            // Update self?.joinedUsers accordingly
        }
    }
}
