//
//  ResultsView.swift
//  Munch
//
//  Created by Mac Howe on 10/14/24.
//

import SwiftUI

struct ResultsView: View {
    @StateObject private var viewModel: ResultsViewModel

    init(circleId: String) {
        _viewModel = StateObject(wrappedValue: ResultsViewModel(circleId: circleId))
    }

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    ProgressView("Loading results...")
                        .padding()
                        .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                } else if let errorMessage = viewModel.errorMessage {
                    VStack(spacing: 10) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.red)
                        Text(errorMessage)
                            .font(.headline)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .padding()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 20) {

                            // List of Restaurants
                            ForEach(Array(viewModel.restaurantResults.enumerated()), id: \.element.id) { index, result in
                                NavigationLink(destination: RestaurantDetailView(restaurant: result.restaurant)) {
                                    RestaurantResultRow(rank: index + 1, result: result)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.top)
                    }
                    .refreshable {
                        await viewModel.fetchResults()
                    }
                }
            }
            .navigationTitle("Top Restaurants")
            
            .onAppear {
                // Start listening for SSE updates in the future
                // viewModel.startListeningForUpdates()
            }
        }
    }
}

struct ResultsView_Previews: PreviewProvider {
    static var previews: some View {
        ResultsView(circleId: generateDummyID()) // sample UUID
    }
}
