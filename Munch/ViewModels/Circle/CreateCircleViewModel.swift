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
    @Published var generatedCode: String?
    @Published var joinedUsers: [String] = []
    @Published var canStartCircle: Bool = false

    private var cancellables = Set<AnyCancellable>()

    func createCircle() {
        // Placeholder for logic to call the CircleService to create the circle
        // Simulate generating a code
        generatedCode = "ABC123"
        
        // Simulate some joined users for preview
        joinedUsers = ["User1", "User2", "User3"]
        canStartCircle = true
    }

    func startCircle() {
        // Placeholder for logic to start the circle
    }
}
