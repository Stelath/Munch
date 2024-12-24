//
//  CreateCircleViewModel.swift
//  Munch
//
//  Created by Alexander Korte on 6/16/24.
//

import Foundation
import CoreLocation
import Combine

@MainActor
class CreateCircleViewModel: ObservableObject {
    
    //    @Published var name: String = ""
    @Published var location: String = ""
    @Published var generatedCode: String?
    @Published var joinedUsers: [User] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var isCircleStarted = false
    
    private let circleService = CircleService.shared
    private let locationService = LocationService()
    private var circleId: String?
    private var user: User?
    
    private var cancellables = Set<AnyCancellable>()
    
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
                guard let user = self.user else {
                    self.errorMessage = "User not authenticated."
                    return
                }
                let (id, code) = try await circleService.createCircle(name: user.name, location: location) // add location options
                
                self.circleId = id
                self.generatedCode = code
                
                print("ID & CODE:", id, code) // DEBUG
                
                // Join the circle
                try await circleService.joinCircle(circleId: id, userID: user.id, userName: user.name)
                
                // Fetch Circle Details
                let circle = try await circleService.getCircle(id: id)
                
                self.joinedUsers = circle.users
                print(joinedUsers) // DEBUG
                
                
            } catch {
                self.errorMessage = error.localizedDescription
            }
            
            isLoading = false
            
        }
    }
    // MARK: - Start Circle
    func startCircle() {
        Task {
            guard let circleId else {
                self.errorMessage = "Circle ID not found."
                return
            }
            do {
                isLoading = true
                // Call the new function in CircleService
                try await circleService.startCircle(circleId: circleId)
                
                // Once started, set local state
                isCircleStarted = true
                isLoading = false

            } catch {
                isLoading = false
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    func getCircleId() -> String? {
        return circleId
    }
    

    /// Called by the View onAppear, typically. We subscribe once to global WebSocket events relevant to this VM.
    func subscribeToWebSocketEvents(_ webSocketManager: WebSocketManager) {
        webSocketManager.eventPublisher
            .sink { [weak self] event in
                guard let self = self else { return }
                switch event {
                case .userJoined(let newUser):
                    // For example: if the newly joined user is for our circle
                    // you might check circleId or other context from the server
                    // If the manager doesn't send "which circle" in userJoined,
                    // you might store that in the user or in "data" from the server
                    // For now, we'll assume it's always relevant:
                    if !self.joinedUsers.contains(where: { $0.id == newUser.id }) {
                        self.joinedUsers.append(newUser)
                    }
                    
                default:
                    break
                }
            }
            .store(in: &cancellables)
    }
    
    // Example for location
    func fillCurrentCity() {
        Task {
            isLoading = true
            errorMessage = nil
            do {
                let userLocation = try await locationService.getCurrentLocation()
                let cityAndState = try await fetchCityAndState(from: userLocation)
                self.location = cityAndState
            } catch {
                self.errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }
    
    private func fetchCityAndState(from location: CLLocation) async throws -> String {
        let geocoder = CLGeocoder()
        let placemarks = try await geocoder.reverseGeocodeLocation(location)
        if let placemark = placemarks.first,
           let city = placemark.locality,
           let state = placemark.administrativeArea {
            return "\(city), \(state)"
        }
        throw NSError(
            domain: "CityStateNotFound",
            code: 0,
            userInfo: [NSLocalizedDescriptionKey: "Unable to determine city and state from location."]
        )
    }
}
