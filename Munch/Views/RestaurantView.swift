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
                .background(Color.black.opacity(0.5))
                .cornerRadius(10)
                .foregroundColor(.white)
            }

            HStack {
                if viewModel.position.width > 0 {
                    Image(systemName: "hand.thumbsup.fill")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.green)
                        .opacity(viewModel.likeOpacity)
                        .rotationEffect(.degrees(-20))
                        .offset(x: -50, y: 0)
                } else if viewModel.position.width < 0 {
                    Image(systemName: "hand.thumbsdown.fill")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.red)
                        .opacity(viewModel.dislikeOpacity)
                        .rotationEffect(.degrees(20))
                        .offset(x: 50, y: 0)
                }
            }
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
    }
}

struct RestaurantView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleRestaurant = Restaurant(
            id: UUID(),
            name: "Sample Restaurant",
            address: "123 Main St",
            images: [],
            coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0),
            mapItem: MKMapItem()
        )
        let viewModel = RestaurantViewModel(restaurant: sampleRestaurant)
        RestaurantView(viewModel: viewModel)
            .frame(height: 600)
            .padding()
    }
}
