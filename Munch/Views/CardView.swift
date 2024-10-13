//
//  CardView.swift
//  Munch
//
//  Edited by Mac Howe on 10/11/2024
//

import SwiftUI
import MapKit

struct CardView: View {
    @ObservedObject var viewModel: CardViewModel
    var onSwipe: ((SwipeDirection) -> Void)?

    private let cardGradient = Gradient(colors: [Color.black.opacity(0.0), Color.black.opacity(0.5)])

    var body: some View {
        ZStack(alignment: .topLeading) {
            if let scene = viewModel.lookAroundScene {
                LookAroundPreview(initialScene: scene)
                LinearGradient(gradient: cardGradient, startPoint: .top, endPoint: .bottom)
            } else {
                Color.gray
                ContentUnavailableView("No Preview Available", systemImage: "eye.slash")
            }

            VStack {
                Spacer()
                VStack(alignment: .leading) {
                    HStack {
                        Text(viewModel.card.name)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                    }
                    Text(viewModel.card.about)
                        .font(.body)
                }
            }
            .padding()
            .foregroundColor(.white)

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
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleCard = Card(
            name: "Sample Restaurant",
            about: "A great place to eat.",
            coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0),
            mapItem: MKMapItem()
        )
        let cardViewModel = CardViewModel(card: sampleCard)
        CardView(viewModel: cardViewModel)
    }
}
//
//func findClosestMapItem(to locationCoordinate: CLLocationCoordinate2D, completion: @escaping (MKMapItem?) -> Void) {
//    // Define a region with a radius around the specified location coordinate
//    let region = MKCoordinateRegion(center: locationCoordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
//    
//    // Create a request to search for points of interest around the specified location
//    let request = MKLocalSearch.Request()
//    request.region = region
//    request.naturalLanguageQuery = "Resturant" // You can change this to search for specific types of places
//    
//    // Create a local search object
//    let search = MKLocalSearch(request: request)
//    
//    // Start the search
//    search.start { response, error in
//        // Check if there is an error or no response
//        guard let response = response, error == nil else {
//            print("Search error: \(error?.localizedDescription ?? "Unknown error")")
//            completion(nil)
//            return
//        }
//        
//        // Find the closest map item to the specified location coordinate
//        let closestMapItem = response.mapItems.min { mapItem1, mapItem2 in
//            let distance1 = CLLocation(latitude: mapItem1.placemark.coordinate.latitude, longitude: mapItem1.placemark.coordinate.longitude).distance(from: CLLocation(latitude: locationCoordinate.latitude, longitude: locationCoordinate.longitude))
//            let distance2 = CLLocation(latitude: mapItem2.placemark.coordinate.latitude, longitude: mapItem2.placemark.coordinate.longitude).distance(from: CLLocation(latitude: locationCoordinate.latitude, longitude: locationCoordinate.longitude))
//            return distance1 < distance2
//        }
//        
//        // Return the closest map item
//        completion(closestMapItem)
//    }
//}
