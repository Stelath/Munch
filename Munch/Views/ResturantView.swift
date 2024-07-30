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
    @State private var showButton = false
    
    
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
                    ForEach(viewModel.restaurants) { resturant in
                        let card = Card(name: resturant.name, about: "", coordinate: resturant.coordinate, mapItem: resturant.mapItem)
                        
                        let _ = print(card.name, card.coordinate.latitude, card.coordinate.longitude)
                        
                        CardView(card: card) { swipedYes in
                            if (swipedYes) {
                                viewModel.yesRestaurants.append(resturant.name)
                            } else {
                                viewModel.noRestaurants.append(resturant.name)
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
                
                
                NavigationLink(destination: ResultView(), isActive: $navigateToResults)  {
                    EmptyView()
                }
            }
        }
        .padding(8)
        .zIndex(1.0)
        
        HStack {
            Button(action: {}) {
                Image(systemName: "x.circle")
            }
            Button(action: {}) {
                Image(systemName: "checkmark.circle")
            }
        }
        .tint(.black)
        .font(.largeTitle)
        .padding()
        HStack {
            Text("\(viewModel.noRestaurants.count)")
            Text("\(viewModel.yesRestaurants.count)")
        }
    }
}

#Preview {
    ResturantView().environmentObject(RestaurantViewModel())
}
