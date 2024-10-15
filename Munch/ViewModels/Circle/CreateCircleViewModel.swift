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
    private var circleId: UUID?
    
    func createCircle(userId: UUID) {
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
                // TODO navigate to the next screen
            } catch {
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    private func startListeningForUpdates() {
        guard let circleId = circleId,
              let url = URL(string: "https://api.yourapp.com/circles/\(circleId.uuidString)/events") else { return }
        sseService.startListening(url: url) { [weak self] eventName, eventData in
            guard let self = self else { return }
            switch eventName {
            case "user_joined":
                if let data = eventData?.data(using: .utf8) {
                    do {
                        let newUser = try JSONDecoder().decode(User.self, from: data)
                        DispatchQueue.main.async {
                            if !self.joinedUsers.contains(where: { $0.id == newUser.id }) {
                                self.joinedUsers.append(newUser)
                            }
                        }
                    } catch {
                        print("Failed to decode user_joined event: \(error.localizedDescription)")
                    }
                }
            case "circle_started":
                DispatchQueue.main.async {
                    self.canStartCircle = true
                    // Navigate to the next screen if needed
                }
            default:
                break
            }
        }
    }

    func stopListeningForUpdates() {
        sseService.stopListening()
    }
}
