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
        ZStack{
            ForEach(viewModel.restaurants) { resturant in
                let card = Card(name: resturant.name, about: "", coordinate: resturant.coordinate, mapItem: resturant.mapItem)
                
                CardView(card: card)
            }
        }
        .padding(8)
        .zIndex(1.0)
        
        HStack {
            Button(action: {}) {
                Image(systemName: "checkmark.circle")
            }
            Button(action: {}) {
                Image(systemName: "x.circle")
            }
        }
        .tint(.black)
        .font(.largeTitle)
        .padding()
    }
}

#Preview {
    ResturantView()
}
