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
            VStack {
                Text("Restaurants Near You")
                    .font(.system(.title2, design: .rounded))
                    .bold()
                    .padding()
                ZStack{
                    ForEach($viewModel.cards) { $card in
                        CardView(card: $card) { swipedRight in
                            viewModel.handleSwipe(direction: swipedRight ? .right : .left)
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
                    .background(.black)
                    .cornerRadius(40)
                    .padding()
                }
                
                HStack {
                    Spacer()
                    Button(action: {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)){
                            viewModel.handleSwipe(direction: .left, moveCard: true)
                            }
                        }) {
                            Image(systemName: "x.circle")
                                .resizable()
                                .frame(width: 60, height: 60)
                        }.disabled(viewModel.currentCardIndex < 0)
                    Spacer()
                    Spacer()
                    Button(action: {
                        withAnimation(.interpolatingSpring(mass: 1.0, stiffness: 50, damping: 8, initialVelocity: 0)) {
                            viewModel.handleSwipe(direction: .right, moveCard: true)
                            }
                        }) {
                            Image(systemName: "checkmark.circle")
                                .resizable()
                                .frame(width: 60, height: 60)
                        }.disabled(viewModel.currentCardIndex < 0)
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
        .zIndex(1.0)
        .navigationDestination(isPresented: $navigateToResults) {
                        ResultView()
            }
        }
    }
}

#Preview {
    RestaurantView()
}
