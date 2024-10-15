//
//  ResturantView.swift
//  Munch
//
//  Created by Alexander Korte on 6/16/24.
//

import SwiftUI

struct SwipeView: View {
    @StateObject private var viewModel: SwipeViewModel
    @State private var navigateToResults = false
    private let circleId: UUID
    
    init(circleId: UUID) {
        self.circleId = circleId
        _viewModel = StateObject(wrappedValue: SwipeViewModel(circleId: circleId))
    }

    var body: some View {
        NavigationStack {
            if viewModel.isLoading {
                ProgressView("Loading Restaurants...")
            } else if let locationError = viewModel.locationError {
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
                        ForEach(viewModel.restaurantViewModels) { restaurantViewModel in
                            RestaurantView(viewModel: restaurantViewModel) { direction in
                                viewModel.handleSwipe(direction: direction)
                            }
                        }
                    }
                    .padding()

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
                        .disabled(viewModel.currentRestaurantViewModel == nil)
                        Spacer()
                        Spacer()
                        Button(action: {
                            viewModel.performSwipe(direction: .right)
                        }) {
                            Image(systemName: "checkmark.circle")
                                .resizable()
                                .frame(width: 60, height: 60)
                        }
                        .disabled(viewModel.currentRestaurantViewModel == nil)
                        Spacer()
                    }
                    .tint(.black)
                    .font(.largeTitle)
                    // TODO: Fix counting the yes and no votes. Just count as we swipe
                    HStack {
                        Spacer()
                        Text("\(viewModel.userNoVotes)")
                        Spacer()
                        Spacer()
                        Text("\(viewModel.userYesVotes)")
                        Spacer()
                    }
                }
                .padding(8)
                .navigationDestination(isPresented: $navigateToResults) {
                    ResultsView(circleId: circleId)
                        .environmentObject(viewModel)
                }
            }
        }
    }
}

#Preview {
    SwipeView(circleId: UUID())
}
