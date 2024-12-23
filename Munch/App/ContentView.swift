//
//  ContentView.swift
//  Munch
//
//  Created by Alexander Korte on 6/16/24.
//


import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var authViewModel: AuthenticationViewModel
    
    var body: some View {
        Group {
            if authViewModel.user != nil {
                CircleTabView()
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Menu {
                                Button(role: .destructive) {
                                    authViewModel.signOut()
                                } label: {
                                    Label("Sign Out", systemImage: "rectangle.portrait.and.arrow.right")
                                }
                            } label: {
                                Image(systemName: "gearshape.fill")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
            } else {
                LoginView()
            }
        }
        .onAppear {
            authViewModel.restoreUserSession()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthenticationViewModel())
}
    
