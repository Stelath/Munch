//
//  CircleTabView.swift
//  Munch
//
//  Created by Mac Howe on 10/14/24.
//
import SwiftUI

struct CircleTabView: View {
    @State private var selectedTab = 0

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
                    Image(systemName: "gearshape.fill")
                        .foregroundColor(.blue)
                        .onTapGesture {
                            // Placeholder for settings 
                        }
                }
            }
        }
    }
}

#Preview {
    CircleTabView()
        .environmentObject(AuthenticationViewModel())
}
