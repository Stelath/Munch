//
//  JoinCircleViewModel.swift
//  Munch
//
//  Created by Mac Howe on 10/14/24.
//

import Foundation
import Combine

class JoinCircleViewModel: ObservableObject {
    @Published var circleCode: String = ""
    @Published var name: String = ""
    @Published var joinedUsers: [User] = []
    @Published var isLoading: Bool = false
    @Published var isWaitingToStart: Bool = false
    @Published var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()
    private let circleService = CircleService()
    private let userService = UserService()
    private let sseService = SSEService()
    private var circleId: String?

    func joinCircle() {
        guard !circleCode.isEmpty else {
            errorMessage = "Circle code cannot be empty."
            return
        }

        isLoading = true
        errorMessage = nil

        circleService.joinCircle(code: circleCode, userName: name)
            .sink(receiveCompletion: { completion in
                self.isLoading = false
                if case let .failure(error) = completion {
                    self.errorMessage = error.localizedDescription
                }
            }, receiveValue: { circle in
                self.circleId = circle.id
                self.joinedUsers = circle.users
                self.isWaitingToStart = true
                self.startListeningForUpdates()
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
