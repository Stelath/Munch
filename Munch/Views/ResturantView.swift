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
                            .padding(EdgeInsets(top: 12, leading: 25, bottom: 12, trailing: 25))
                        
                    })
                    .background(.black)
                    .cornerRadius(40)
                    .padding()
                    .opacity(1)
                }
                
                
//                NavigationLink(destination: ResultView(), isActive: $navigateToResults)  {
//                    EmptyView()
//                }
            }
        }
        .padding(8)
        .zIndex(1.0)
        
        HStack {
            Spacer()
            Button(action: {
                withAnimation(.interpolatingSpring(mass: 1.0, stiffness: 50, damping: 8, initialVelocity: 0)) {
                    viewModel.swipeLeft(moveCard: true)
                    }
                }) {
                    Image(systemName: "x.circle")
                        .resizable()
                        .frame(width: 60, height: 60)
                }.disabled(viewModel.currentCardI < 0)
            Spacer()
            Spacer()
            Button(action: {
                withAnimation(.interpolatingSpring(mass: 1.0, stiffness: 50, damping: 8, initialVelocity: 0)) {
                    viewModel.swipeRight(moveCard: true)
                    }
                }) {
                    Image(systemName: "checkmark.circle")
                        .resizable()
                        .frame(width: 60, height: 60)
                }.disabled(viewModel.currentCardI < 0)
            Spacer()
        }
        .tint(.black)
        .font(.largeTitle)
//        .padding()
        HStack {
            Spacer()
            Text("\(viewModel.noRestaurants.count)")
            Spacer()
            Spacer()
            Text("\(viewModel.yesRestaurants.count)")
            Spacer()
        }
    }
}

#Preview {
    ResturantView().environmentObject(RestaurantViewModel())
}
