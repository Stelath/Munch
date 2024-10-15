//
//  RestaurantDetailView.swift
//  Munch
//
//  Created by Mac Howe on 10/14/24.
//

import SwiftUI
import MapKit

struct RestaurantDetailView: View {
    let restaurant: Restaurant

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Restaurant Image
                if let firstImage = restaurant.images.first, let imageURL = URL(string: firstImage) {
                    AsyncImage(url: imageURL) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(maxWidth: .infinity, maxHeight: 200)
                                .background(Color.gray.opacity(0.1))
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: .infinity, maxHeight: 200)
                                .clipped()
                        case .failure:
                            Image(systemName: "photo.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: .infinity, maxHeight: 200)
                                .foregroundColor(.gray)
                                .background(Color.gray.opacity(0.1))
                        @unknown default:
                            EmptyView()
                        }
                    }
                } else {
                    // Default Placeholder Image
                    Image(systemName: "photo.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity, maxHeight: 200)
                        .foregroundColor(.gray)
                        .background(Color.gray.opacity(0.1))
                }

                // Restaurant Information
                VStack(alignment: .leading, spacing: 10) {
                    Text(restaurant.name)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)

                    Text(restaurant.address)
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    // Placeholder for additional details
                    Text("Details about the restaurant can go here. Include menus, reviews, contact information, etc.")
                        .font(.body)
                        .foregroundColor(.primary)
                }
                .padding(.horizontal)

                // Map View
                Map(coordinateRegion: .constant(MKCoordinateRegion(
                    center: restaurant.coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
                )), annotationItems: [restaurant]) { restaurant in
                    MapMarker(coordinate: restaurant.coordinate, tint: .blue)
                }
                .frame(height: 200)
                .cornerRadius(15)
                .padding(.horizontal)

                Spacer()
            }
            .padding(.bottom)
        }
        .navigationTitle(restaurant.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct RestaurantDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleRestaurant = Restaurant(
            id: UUID(),
            name: "Sushi Place",
            address: "123 Main St",
            images: ["https://example.com/image.jpg"], // Replace with valid image URLs
            coordinate: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
            mapItem: MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)))
        )
        RestaurantDetailView(restaurant: sampleRestaurant)
    }
}
