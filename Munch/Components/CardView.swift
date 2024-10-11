/*
 Copyright 2021 Franck-Stephane Ndame Mpouli
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

//
//  CardView.swift
//  Munch
//
//  Edited by Mac Howe on 10/11/2024
//

import SwiftUI
import MapKit

public enum SwipeState {
    case none, left, right
}

struct CardView: View {
    @Binding var card: Card
    @State private var lookAroundScene: MKLookAroundScene?
    
    var action: ((Bool) -> Void)? = nil
    

    let cardGradient = Gradient(colors: [Color.black.opacity(0.0), Color.black.opacity(0.5)])
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            //This is for the look of the cards, the "Street View" look on each
            //card
            if let scene = lookAroundScene {
                LookAroundPreview(initialScene: scene)
                LinearGradient(gradient: cardGradient, startPoint: .top, endPoint: .bottom)
            } else {
                Color.gray // no gradient when no preview
                ContentUnavailableView("No Preview Available", systemImage: "eye.slash")
                 
            }
            //            Image(card.imageName)
            //                .resizable()
            //                .clipped()
            
            
            // Linear Gradient -- moved for now so there is not gradient when there is not preview
//            LinearGradient(gradient: cardGradient, startPoint: .top, endPoint: .bottom)
            //Puts the name of the restaurant at the bottom of the card
            VStack {
                Spacer()
                VStack(alignment: .leading){
                    HStack {
                        Text(card.name).font(.largeTitle).fontWeight(.bold)
                    }
                    Text(card.about).font(.body)
                }
            }
            .padding()
            .foregroundColor(.white)
            
            HStack {
                
                // YES Symbol
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
                    .opacity(Double(card.x / 10 - 1))
                
                Spacer()
                
                // NOPE Symbol
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
                    .opacity(Double(card.x / 10 * -1 - 1))
            }.padding(25)/*.padding(.top, 20)*/
            
        }.onAppear {
            fetchLookAroundPreview()
        }
        
        .cornerRadius(20)
        .offset(x: card.x, y: card.y)
        .rotationEffect(.init(degrees: card.degree))
        .gesture (
            //allows us to drag around card
            DragGesture()
                .onChanged { value in
                    withAnimation(.default) {
                        card.x = value.translation.width
                        card.y = value.translation.height
                        card.degree = 7 * (value.translation.width > 0 ? 1 : -1)
                    }
                }
                .onEnded { value in
                    handleSwipeEnd(value: value)
                }
        )
    }
    
    func handleSwipeEnd(value: DragGesture.Value) {
            //when the card is released if it is still within certain bounds
            //spring back to where it originally was
            withAnimation(.interpolatingSpring(mass: 1.0, stiffness: 50, damping: 8, initialVelocity: 0)) {
                switch value.translation.width {
                case 0...100:
                    card.x = 0; card.degree = 0; card.y = 0
                case let x where x > 100:
                    card.x = 500; card.degree = 12
                    action?(true)
                case (-100)...(-1):
                    card.x = 0; card.degree = 0; card.y = 0
                case let x where x < -100:
                    card.x = -500; card.degree = -12
                    action?(false)
                default:
                    card.x = 0; card.y = 0
                }
            }
        }
}

extension CardView {
    func fetchLookAroundPreview() {
        lookAroundScene = nil
        Task {
            let request = MKLookAroundSceneRequest(mapItem: card.mapItem)
            lookAroundScene = try? await request.scene
        }
    }
}



struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardPreviewWrapper()
    }
    
    struct CardPreviewWrapper: View {
        @State private var card: Card = Card(name: "", about: "", coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0), mapItem: MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0))))
        @State private var selectedMapItem: MKMapItem? = nil
        @State private var mapItemPresented: Bool = true
        private let locationCoordinate = CLLocationCoordinate2D(latitude: 37.3231985, longitude: -122.0098249)
        
        var body: some View {
            ZStack {
//                mapItemDetailSheet(isPresented: $mapItemPresented, item: selectedMapItem, displaysMap: true)
                CardView(card: $card)
            }
            .onAppear {
                findClosestMapItem(to: locationCoordinate) { closestMapItem in
                    if let closestMapItem = closestMapItem {
                        print("Closest map item: \(closestMapItem.name ?? "Unknown")")
                        print("Location: \(closestMapItem.placemark.coordinate.latitude), \(closestMapItem.placemark.coordinate.longitude)")
                        
                        DispatchQueue.main.async {
                            card = Card(name: "Testing", about: "Guess Who!", coordinate: locationCoordinate, mapItem: closestMapItem)
//                            selectedMapItem = closestMapItem
                        }
                    } else {
                        print("No map item found.")
                    }
                }
            }
        }
    }
}

func findClosestMapItem(to locationCoordinate: CLLocationCoordinate2D, completion: @escaping (MKMapItem?) -> Void) {
    // Define a region with a radius around the specified location coordinate
    let region = MKCoordinateRegion(center: locationCoordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
    
    // Create a request to search for points of interest around the specified location
    let request = MKLocalSearch.Request()
    request.region = region
    request.naturalLanguageQuery = "Resturant" // You can change this to search for specific types of places
    
    // Create a local search object
    let search = MKLocalSearch(request: request)
    
    // Start the search
    search.start { response, error in
        // Check if there is an error or no response
        guard let response = response, error == nil else {
            print("Search error: \(error?.localizedDescription ?? "Unknown error")")
            completion(nil)
            return
        }
        
        // Find the closest map item to the specified location coordinate
        let closestMapItem = response.mapItems.min { mapItem1, mapItem2 in
            let distance1 = CLLocation(latitude: mapItem1.placemark.coordinate.latitude, longitude: mapItem1.placemark.coordinate.longitude).distance(from: CLLocation(latitude: locationCoordinate.latitude, longitude: locationCoordinate.longitude))
            let distance2 = CLLocation(latitude: mapItem2.placemark.coordinate.latitude, longitude: mapItem2.placemark.coordinate.longitude).distance(from: CLLocation(latitude: locationCoordinate.latitude, longitude: locationCoordinate.longitude))
            return distance1 < distance2
        }
        
        // Return the closest map item
        completion(closestMapItem)
    }
}
