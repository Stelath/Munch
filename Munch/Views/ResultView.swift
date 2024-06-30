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
        Text("Top Restaurants")
            .foregroundColor(.black)
            .font(.system(.title2, design: .rounded))
            .bold()
            .padding(EdgeInsets(top: 16, leading: 32, bottom: 16, trailing: 32))
        ScrollView {
            VStack {
                ForEach(0..<viewModel.yesRestaurants.count, id: \.self) { i in
                    HStack {
                        Text("\(i + 1).")
                            .frame(width: 25, alignment: .leading)
                            .foregroundColor(.white)
                        Text(viewModel.yesRestaurants[i])
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding(5)
                    .background(Color.black)
                    .cornerRadius(8)
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

