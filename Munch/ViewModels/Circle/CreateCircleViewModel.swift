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
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let circleService = CircleService.shared
    private let sseService = SSEService()
    private var circleId: String?
    
    deinit {
        sseService.stopListening()
    }
    
    func createCircle() {
        Task {
            errorMessage = nil
            isLoading = true
            do {
                //Create the circle
                let (id, code) = try await circleService.createCircle(name: name, location: location) // add location options
                self.circleId = id
                self.generatedCode = code
                
                print("ID & CODE:", id, code) // DEBUG
                
                // Join the circle
                let userID = generateDummyID()
                let userName = name // get user input
                try await circleService.joinCircle(circleId: id, userID: userID, userName: userName)
                
                // Fetch Circle Details
                let circle = try await circleService.getCircle(id: id)
                self.joinedUsers = circle.users
//                self.joinedUsers.append(User(id: "111", name: "Mac")) // Testing
//                self.joinedUsers.append(User(id: "222", name: "AP"))
                print(joinedUsers)
                
                startListeningForUpdates()
            } catch {
                self.errorMessage = error.localizedDescription
            }
            isLoading = false
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
                            DispatchQueue.main.async {
                                if !self.joinedUsers.contains(where: { $0.id == newUser.id }) {
                                    self.joinedUsers.append(newUser)
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
