//
//  CardView.swift
//  Munch
//
//  Edited by Mac Howe on 10/11/2024
//

import SwiftUI
import MapKit


struct RestaurantView: View {
    @ObservedObject var viewModel: RestaurantViewModel
    var onSwipe: ((SwipeDirection) -> Void)?

    private let cardGradient = Gradient(colors: [Color.black.opacity(0.0), Color.black.opacity(0.5)])

    var body: some View {
        ZStack(alignment: .topLeading) {
            if let scene = viewModel.lookAroundScene {
                LookAroundPreview(initialScene: scene)
                    .edgesIgnoringSafeArea(.all)
                LinearGradient(gradient: cardGradient, startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
            } else {
                Color.gray
                ContentUnavailableView("No Preview Available", systemImage: "eye.slash")
            }
            VStack {
                Spacer()
                VStack(alignment: .leading) {
                    Text(viewModel.restaurant.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Text(viewModel.restaurant.address)
                        .font(.body)
                }
                .padding()
                .foregroundColor(.white)
            }
            
            HStack {
                // Swipe Right
                Image(systemName: "hand.thumbsup")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60, height: 60)
                    .foregroundColor(.green)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.green, lineWidth: 2)
                    )
                    .rotationEffect(.degrees(-12))
                    .opacity(viewModel.likeOpacity)
                
                Spacer()
                
                // Swipe Left
                Image(systemName: "hand.thumbsdown")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60, height: 60)
                    .foregroundColor(.red)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.red, lineWidth: 2)
                    )
                    .rotationEffect(.degrees(12))
                    .opacity(viewModel.dislikeOpacity)
            }
            .padding(25)
        }
        .cornerRadius(20)
        .offset(x: viewModel.position.width, y: viewModel.position.height)
        .rotationEffect(.degrees(viewModel.rotation))
        .gesture(
            DragGesture()
                .onChanged { value in
                    viewModel.onDragChanged(value: value)
                }
                .onEnded { value in
                    if let direction = viewModel.onDragEnded(value: value) {
                        onSwipe?(direction)
                    }
                }
        )
        .onAppear {
            viewModel.fetchLookAroundPreview()
        }
    }
}

struct RestaurantView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleRestaurant = Restaurant(
            id: UUID(),
            name: "Sample Restaurant",
            address: "123 Main St",
            imageURLs: [],
            logoURL: nil

        )
        let viewModel = RestaurantViewModel(restaurant: sampleRestaurant)
        RestaurantView(viewModel: viewModel)
            .frame(height: 600)
            .padding()
    }
}
