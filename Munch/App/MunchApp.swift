//
//  MunchApp.swift
//  Munch
//
//  Created by Alexander Korte on 6/16/24.
//

import SwiftUI

@main
struct MunchApp: App {
    @StateObject private var authViewModel = AuthenticationViewModel()
    
    private let webSocketBaseURL = URL(string: "ws://localhost:3000")!
    @StateObject private var webSocketManager = WebSocketManager(baseURL: URL(string: "ws://localhost:3000")!)

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authViewModel)
                .environmentObject(webSocketManager)
                .onAppear {
                    
                    webSocketManager.connect()
                }
        }
    }
}
