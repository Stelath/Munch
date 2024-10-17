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
    
    func createCircle() {
        Task {
//            errorMessage = nil
            do {
                // Step 1: Create the circle
                let (id, code) = try await circleService.createCircle(name: name, location: location)
                
                print("ID & CODE:", id, code)
                
                // Step 2: Join the circle as the creator
                let userID = generateDummyID()
                let userName = "Default User" // You can modify this to take user input later
                try await circleService.joinCircle(circleId: id, userID: userID, userName: userName)
                
                // Step 3: Fetch the updated circle details
                let fetchedCircle = try await circleService.getCircle(id: id)
                print("GOT A CIRCLE ME BOY:", fetchedCircle)
                
                // Update published properties
                self.generatedCode = code
                self.circleId = id
                self.joinedUsers = fetchedCircle.users
            } catch {
//                self.errorMessage = error.localizedDescription
            }
        }
    }
    
//    func startCircle() {
//        Task {
//            do {
//                guard let circleId = circleId else { return }
//                let circle = try await circleService.startCircle(circleId: circleId)
//                self.canStartCircle = circle.started
//                // TODO navigate to the next screen
//            } catch {
//                self.errorMessage = error.localizedDescription
//            }
//        }
//    }
    
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
//                    self.canStartCircle = true
//                    // Navigate to the next screen if needed
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
