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
    @Published var joinedUsers: [String] = []
    @Published var isLoading: Bool = false
    @Published var isWaitingToStart: Bool = false
    @Published var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()

    func joinCircle() {
        guard !circleCode.isEmpty else {
            errorMessage = "Circle code cannot be empty."
            return
        }

        isLoading = true
        errorMessage = nil

        // Placeholder for logic to call CircleService to join the circle
        // Simulate a successful join
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.isLoading = false
            self.isWaitingToStart = true

            // Simulate some joined users for preview
            self.joinedUsers = ["User1", "User2", "User3"]
        }
    }
}
