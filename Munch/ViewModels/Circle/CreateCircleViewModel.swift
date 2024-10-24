//
//  CreateCircleViewModel.swift
//  Munch
//
//  Created by Alexander Korte on 6/16/24.
//

import Foundation
import CoreLocation

class CreateCircleViewModel: ObservableObject {
    
//    @Published var name: String = ""
    @Published var location: String = ""
    @Published var generatedCode: String?
    @Published var joinedUsers: [User] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let circleService = CircleService.shared
    private let sseService = SSEService()
    private let locationService = LocationService()
    private var circleId: String?
    private var user: User?
    
    deinit {
        sseService.stopListening()
    }
    
    func setUser(_ user: User?) {
        self.user = user
    }
    
    func createCircle() {
        Task {
            await MainActor.run {
                errorMessage = nil
                isLoading = true
            }
            do {
                sseService.stopListening() // If there was already a service running
                //Create the circle
                guard let user = self.user else {
                    self.errorMessage = "User not authenticated."
                    return
                }
                let (id, code) = try await circleService.createCircle(name: user.name, location: location) // add location options
                await MainActor.run{
                    self.circleId = id
                    self.generatedCode = code
                }
                print("ID & CODE:", id, code) // DEBUG
                
                // Join the circle
                try await circleService.joinCircle(circleId: id, userID: user.id, userName: user.name)
                
                // Fetch Circle Details
                let circle = try await circleService.getCircle(id: id)
                await MainActor.run {
                    self.joinedUsers = circle.users
                }
                print(joinedUsers) // DEBUG
        
                startListeningForUpdates()
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                }
            }
            await MainActor.run {
                isLoading = false
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
    


    func fillCurrentCity() {
        Task {
            await MainActor.run {
                self.isLoading = true
                self.errorMessage = nil
            }
            do {
                let userLocation = try await locationService.getCurrentLocation()
                let cityAndState = try await fetchCityAndState(from: userLocation)
                await MainActor.run {
                    self.location = cityAndState
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                }
            }
            await MainActor.run {
                self.isLoading = false
            }
        }
    }

    private func fetchCityAndState(from location: CLLocation) async throws -> String {
        let geocoder = CLGeocoder()
        let placemarks = try await geocoder.reverseGeocodeLocation(location)
        if let placemark = placemarks.first,
           let city = placemark.locality,
           let state = placemark.administrativeArea {
            return "\(city), \(state)"
        } else {
            throw NSError(
                domain: "CityStateNotFound",
                code: 0,
                userInfo: [NSLocalizedDescriptionKey: "Unable to determine city and state from location."]
            )
        }
    }
}
