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

    func createCircle(userId: String) async {
        do {
            let circle = try await circleService.createCircle(userId: userId, name: name, location: location)
            self.generatedCode = circle.code
            self.circleId = circle.id
            self.joinedUsers = circle.users
            self.startListeningForUpdates()
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }

    func startCircle() {
        guard let circleId = circleId else { return }
        circleService.startCircle(circleId: circleId)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    self.errorMessage = error.localizedDescription
                }
            }, receiveValue: {
                // Handle success (e.g., navigate to the next screen)
            })
            .store(in: &cancellables)
    }

    private func startListeningForUpdates() {
        guard let circleId = circleId else { return }
        sseService.circleUpdates
            .receive(on: DispatchQueue.main)
            .sink { update in
                // Update `joinedUsers` based on the update
                self.joinedUsers.append(update.user)
            }
            .store(in: &cancellables)
        sseService.startListening(circleId: circleId)
    }
}
