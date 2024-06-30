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
            VStack {
                Text("Restaurants Near You")
                    .font(.system(.title2, design: .rounded))
                    .bold()
                    .padding()
                ZStack{
                    ForEach(viewModel.restaurants) { resturant in
                        let card = Card(name: resturant.name, about: "", coordinate: resturant.coordinate, mapItem: resturant.mapItem)
                        
                        CardView(card: card)
                            .environmentObject(viewModel)
                    }
                }
                if (viewModel.restaurants.count <= (viewModel.yesRestaurants.count + viewModel.noRestaurants.count)) {
                    NavigationLink(destination: ResultView().environmentObject(viewModel)) {
                        
                        Text("Top Restaurants")
                            .foregroundColor(.white)
                            .font(.system(.title2, design: .rounded))
                            .bold()
                            .padding(EdgeInsets(top: 16, leading: 32, bottom: 16, trailing: 32))
                    }
                    .background(.black)
                    .cornerRadius(40)
                    .padding()
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
        }.environmentObject(viewModel)
    }
}
    
#Preview {
    ResturantView().environmentObject(RestaurantViewModel())
}
