//
//  ResultView.swift
//  Munch
//
//  Created by John Severson on 6/28/24.
//

import SwiftUI

struct ResultView: View {
    @EnvironmentObject var viewModel: RestaurantViewModel

    
    var body: some View {
// gotta get that sweet backend code here, with a little frequency
// map action to find the restaurant(s) with the most upvotes
// also thinking about adding a feature to get directions to the restaurant
        ScrollView {
            VStack {
                ForEach(0..<viewModel.yesRestaurants.count, id: \.self) { i in
                    Text("\(i+1) \(viewModel.yesRestaurants[i])")
                }
            }
        }
    }
}


//struct ResultView_Previews: PreviewProvider {
   // @State static var viewModel = RestaurantViewModel()

    //static var previews: some View {
        //ResultView(viewModel: $viewModel)
    //}
//}

