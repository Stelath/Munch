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
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authViewModel)
        }
    }
}
    
