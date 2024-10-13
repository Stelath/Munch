//
//  ResturantView.swift
//  Munch
//
//  Created by Alexander Korte on 6/16/24.
//

import SwiftUI
import MapKit

struct RestaurantView: View {
    @StateObject private var viewModel = RestaurantViewModel()
    @State private var navigateToResults = false

    var body: some View {
        NavigationStack {
            if viewModel.isLoading {
                ProgressView("Loading Restaurants...")
                    .onAppear {
                        viewModel.locationService.startUpdatingLocation()
                    }
            } else if let locationError = viewModel.locationService.locationError {
                // Handle location errors
                VStack {
                    Text("Location Error")
                        .font(.title)
                        .padding()
                    Text(locationError.localizedDescription)
                        .padding()
                    Button("Open Settings") {
                        if let url = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(url)
                        }
                    }
                    .padding()
                }
            } else {
                VStack {
                    Text("Restaurants Near You")
                        .font(.system(.title2, design: .rounded))
                        .bold()
                        .padding()

                    ZStack {
                        ForEach(viewModel.cardViewModels) { cardViewModel in
                            CardView(viewModel: cardViewModel) { direction in
                                viewModel.handleSwipe(direction: direction)
                            }
                        }
                    }

                    if viewModel.isAllRestaurantsSwiped {
                        Button(action: {
                            navigateToResults = true
                        }) {
                            Text("See Results")
                                .foregroundColor(.white)
                                .font(.system(.title2, design: .rounded))
                                .bold()
                                .padding(.horizontal, 25)
                                .padding(.vertical, 12)
                        }
                        .background(Color.black)
                        .cornerRadius(40)
                        .padding()
                    }

                    HStack {
                        Spacer()
                        Button(action: {
                            viewModel.performSwipe(direction: .left)
                        }) {
                            Image(systemName: "x.circle")
                                .resizable()
                                .frame(width: 60, height: 60)
                        }
                        .disabled(viewModel.currentCardViewModel == nil)
                        Spacer()
                        Spacer()
                        Button(action: {
                            viewModel.performSwipe(direction: .right)
                        }) {
                            Image(systemName: "checkmark.circle")
                                .resizable()
                                .frame(width: 60, height: 60)
                        }
                        .disabled(viewModel.currentCardViewModel == nil)
                        Spacer()
                    }
                    .tint(.black)
                    .font(.largeTitle)

                    HStack {
                        Spacer()
                        Text("\(viewModel.noRestaurants.count)")
                        Spacer()
                        Spacer()
                        Text("\(viewModel.yesRestaurants.count)")
                        Spacer()
                    }
                }
                .padding(8)
                .navigationDestination(isPresented: $navigateToResults) {
                    ResultView()
                }
            }
        }
    }
}

#Preview {
    RestaurantView()
}
