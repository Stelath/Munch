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
    @StateObject private var viewModel = RestaurantDetailViewModel()


    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Restaurant Image
                if let firstImage = restaurant.imageURLs.first, let imageURL = URL(string: firstImage) {
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

//                if viewModel.isMapLoaded, let coordinate = viewModel.coordinate {
//                    Map(coordinateRegion: $viewModel.region, interactionModes: .all, showsUserLocation: false, annotationItems: [coordinate]) { coordinate in
//                        MapPin(coordinate: coordinate, tint: .red)
//                    }
//                    .frame(height: 200)
//                    .cornerRadius(15)
//                    .padding(.horizontal)
//                } else if !viewModel.isMapLoaded {
//                    ProgressView("Loading Map...")
//                        .frame(height: 200)
//                        .cornerRadius(15)
//                        .padding(.horizontal)
//                } else {
//                    Text("Unable to load map for this address.")
//                        .foregroundColor(.gray)
//                        .frame(height: 200)
//                        .cornerRadius(15)
//                        .padding(.horizontal)
//                }

                Spacer()
            }
            .padding(.bottom)
        }
        .navigationTitle(restaurant.name)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.fetchCoordinate(for: restaurant.address)
        }
    }
}


// Helper struct for annotation
struct AnnotationItem: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

struct RestaurantDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleRestaurant = Restaurant(
            id: UUID(),
            name: "Sushi Place",
            address: "123 Main St",
            imageURLs: ["https://example.com/image.jpg"],
            logoURL: nil
        )
        RestaurantDetailView(restaurant: sampleRestaurant)
    }
}
