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
    @Published var name: String = "Default User"
    @Published var joinedUsers: [User] = []
    @Published var isLoading: Bool = false
    @Published var isWaitingToStart: Bool = false
    @Published var errorMessage: String?

    private let circleService = CircleService()
    private let sseService = SSEService()
    private var circleId: String?


    func joinCircle() {
        Task {
            isLoading = true
            errorMessage = nil
            do {
                // Step 1: Fetch the circle ID using the provided code
                let codeResponse = try await circleService.fetchCode(code: circleCode)
                let circleId = codeResponse.circleId
                
                // Step 2: Join the circle with a random user ID and default username
                let userID = UUID().uuidString
                let userName = name
                try await circleService.joinCircle(circleId: circleId, userID: userID, userName: userName)
                
                // Step 3: Fetch the updated circle details
                let fetchedCircle = try await circleService.getCircle(id: circleId)
                
                // Update published properties
                self.joinedUsers = fetchedCircle.users
            } catch {
                self.errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }
    
//    private func startListeningForUpdates() {
//        guard let circleId = circleId,
//              let url = URL(string: "https://api.yourapp.com/circles/\(circleId.uuidString)/events") else { return }
//        sseService.startListening(url: url) { [weak self] eventName, eventData in
//            guard let self = self else { return }
//            switch eventName {
//            case "user_joined":
//                if let data = eventData?.data(using: .utf8) {
//                    do {
//                        let newUser = try JSONDecoder().decode(User.self, from: data)
//                        DispatchQueue.main.async {
//                            if !self.joinedUsers.contains(where: { $0.id == newUser.id }) {
//                                self.joinedUsers.append(newUser)
//                            }
//                        }
//                    } catch {
//                        print("Failed to decode user_joined event: \(error.localizedDescription)")
//                    }
//                }
//            case "circle_started":
//                DispatchQueue.main.async {
//                    self.isWaitingToStart = false
//                    // Navigate to SwipeView or appropriate screen
//                }
//            default:
//                break
//            }
//        }
//    }
//
//    func stopListeningForUpdates() {
//        sseService.stopListening()
//    }
}
