//
//  ResturantView.swift
//  Munch
//
//  Created by Alexander Korte on 6/16/24.
//

import SwiftUI
import MapKit

struct ResturantView: View {
    @StateObject private var viewModel = RestaurantViewModel()
    @State private var navigateToResults = false
    
    
    var body: some View {
        //        NavigationView {
        //            List(viewModel.restaurants) { restaurant in
        //                VStack(alignment: .leading) {
        //                    Text(restaurant.name)
        //                        .font(.headline)
        //                    Text(restaurant.address)
        //                        .font(.subheadline)
        //                }
        //            }
        //            .navigationTitle("Nearby Restaurants")
        //        }
        NavigationView {
            VStack {
            VStack {
                Text("Restaurants Near You")
                    .font(.system(.title2, design: .rounded))
                    .bold()
                    .padding()
                ZStack{
                    ForEach($viewModel.cards) { $card in
                        CardView(card: $card) { swipedYes in
                            if (swipedYes) {
                                viewModel.swipeRight(moveCard: false)
                            } else {
                                viewModel.swipeLeft(moveCard: false)
                            }
                        }
                    }
                }
                
                if (viewModel.restaurants.count == (viewModel.yesRestaurants.count + viewModel.noRestaurants.count)) {
                    Button(action: {
                        navigateToResults = true
                    }, label: {
                        Text("See Results")
                            .foregroundColor(.white)
                            .font(.system(.title2, design: .rounded))
                            .bold()
                            .padding(EdgeInsets(top: 16, leading: 32, bottom: 16, trailing: 32))
                    }
                    .background(.black)
                    .cornerRadius(40)
                    .padding()
                           
                )}
                
//                NavigationLink(destination: ResultView(), isActive: $navigateToResults)  {
//                    EmptyView()
//                }
            }
        }
        .padding(8)
        .zIndex(1.0)
        
        HStack {
            Button(action: {
                withAnimation(.interpolatingSpring(mass: 1.0, stiffness: 50, damping: 8, initialVelocity: 0)) {
                    viewModel.swipeLeft(moveCard: true)
                }
            }) {
                Image(systemName: "x.circle")
            }.disabled(viewModel.currentCard < 0)
            Button(action: {
                withAnimation(.interpolatingSpring(mass: 1.0, stiffness: 50, damping: 8, initialVelocity: 0)) {
                    viewModel.swipeRight(moveCard: true)
                }
            }) {
                Image(systemName: "checkmark.circle")
            }.disabled(viewModel.currentCard < 0)
        }
        }.environmentObject(viewModel)
    }
}

#Preview {
    ResturantView().environmentObject(RestaurantViewModel())
}
