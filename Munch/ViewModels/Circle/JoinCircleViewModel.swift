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
//    @Published var name: String = ""
    @Published var joinedUsers: [User] = []
    @Published var isLoading: Bool = false
    @Published var isWaitingToStart: Bool = false
    @Published var errorMessage: String?

    private let circleService = CircleService.shared
    private var circleId: String?
    private var user: User?

    private var cancellables = Set<AnyCancellable>()
    
    func setUser(_ user: User?) {
        self.user = user
    }
    
    func joinCircle() {
        Task {
            isLoading = true
            errorMessage = nil
            do {
                // 1) Convert circle code to circleId
                let codeResponse = try await circleService.fetchCode(code: circleCode)
                let circleId = codeResponse.circleId
                self.circleId = circleId
                
                // 2) Join
                guard let user = self.user else {
                    self.errorMessage = "User not authenticated."
                    return
                }
                try await circleService.joinCircle(circleId: circleId, userID: user.id, userName: user.name)
                
                // 3) Fetch circle info
                let circle = try await circleService.getCircle(id: circleId)
                self.joinedUsers = circle.users
                self.isWaitingToStart = !circle.started
            } catch {
                self.errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }
    
    /// Subscribe to shared WebSocket events
    func subscribeToWebSocketEvents(_ webSocketManager: WebSocketManager) {
        webSocketManager.eventPublisher
            .sink { [weak self] event in
                guard let self = self else { return }
                
                switch event {
                case .userJoined(let newUser):
                    // If the new user belongs to our circle, add them
                    if !self.joinedUsers.contains(where: { $0.id == newUser.id }) {
                        self.joinedUsers.append(newUser)
                    }
                case .circleStarted(let circleId):
                    // If circle started matches our circleId
                    if circleId == self.circleId {
                        self.isWaitingToStart = false
                    }
                default:
                    break
                }
            }
            .store(in: &cancellables)
    }
}
