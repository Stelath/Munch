//
//  CircleTabView.swift
//  Munch
//
//  Created by Mac Howe on 10/14/24.
//
import SwiftUI

struct CircleTabView: View {
    @State private var selectedTab = 0
    @EnvironmentObject private var authViewModel: AuthenticationViewModel
    
    var body: some View {
        NavigationStack {
            TabView(selection: $selectedTab) {
                CreateCircleView()
                    .tabItem {
                        Label("Create", systemImage: "plus.circle")
                    }
                    .tag(0)

                JoinCircleView()
                    .tabItem {
                        Label("Join", systemImage: "person.2.circle")
                    }
                    .tag(1)
            }
            .accentColor(.blue)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                        .foregroundColor(.blue)
                        .onTapGesture {
                            authViewModel.signOut()
                            print("out")
                        }
                }
            }
        }
    }
}

#Preview {
    CircleTabView()
        .environmentObject(AuthenticationViewModel())
        .environmentObject(WebSocketManager(baseURL: URL(string: "https://example.com")!))
}
