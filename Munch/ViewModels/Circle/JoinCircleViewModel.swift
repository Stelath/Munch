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
    private let sseService = SSEService()
    private var circleId: String?
    private var user: User?

    deinit {
        sseService.stopListening()
    }
    
    func setUser(_ user: User?) {
        self.user = user
    }
    
    func joinCircle() {
        Task {
            await MainActor.run{
                isLoading = true
                errorMessage = nil
            }
            do {
                // Fetch the circle ID using code
                let codeResponse = try await circleService.fetchCode(code: circleCode)
                let circleId = codeResponse.circleId
                await MainActor.run {
                    self.circleId = circleId
                }
                print("Circle ID: \(circleId)") // DEBUG
                
                // Join the circle
                guard let user = self.user else {
                    self.errorMessage = "User not authenticated."
                    return
                }
                try await circleService.joinCircle(circleId: circleId, userID: user.id, userName: user.name)
                
                print("here")
                // Fetch Circle Details
                let circle = try await circleService.getCircle(id: circleId)
                await MainActor.run {
                    self.joinedUsers = circle.users
                    self.isWaitingToStart = true
                }
                print("here")
                
                startListeningForUpdates()
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    debugPrint(error)
                }
            }
            await MainActor.run {
                self.isLoading = false
            }
        }
    }
    private func startListeningForUpdates() {
        guard let circleId = circleId,
              let url = URL(string: "http://localhost:3000/circles/\(circleId)/events") else { return }
        sseService.startListening(url: url) { [weak self] eventName, eventData in
            guard let self = self else { return }
            switch eventName {
            case "message":
                if let data = eventData?.data(using: .utf8) {
                    do {
                        let eventDict = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                        if let userID = eventDict?["userID"] as? String,
                           let userName = eventDict?["userName"] as? String {
                            let newUser = User(id: userID, name: userName)
                            Task {
                                await MainActor.run {
                                    if !self.joinedUsers.contains(where: { $0.id == newUser.id }) {
                                        self.joinedUsers.append(newUser)
                                    }
                                }
                            }
                        }
                    } catch {
                        print("Failed to decode SSE event: \(error.localizedDescription)")
                    }
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
