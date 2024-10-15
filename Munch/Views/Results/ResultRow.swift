//
//  RestaurantResultRow.swift
//  Munch
//
//  Created by Mac Howe on 10/14/24.
//

import SwiftUI
import MapKit

struct RestaurantResultRow: View {
    let rank: Int
    let result: RestaurantVoteResult

    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            // Rank Number with Badge
            Text("\(rank)")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(width: 30, height: 30)
                .background(Color.blue)
                .clipShape(.circle)
                .accessibilityLabel("Rank \(rank)")

            // Restaurant Details with Image
            HStack(spacing: 15) {
                // Image Placeholder
                if let firstImage = result.restaurant.images.first, let imageURL = URL(string: firstImage) {
                    AsyncImage(url: imageURL) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(width: 60, height: 60)
                                .background(Color.gray.opacity(0.1))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 60, height: 60)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .accessibilityHidden(true)
                        case .failure:
                            Image(systemName: "photo.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                                .foregroundColor(.gray)
                                .background(Color.gray.opacity(0.1))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .accessibilityHidden(true)
                        @unknown default:
                            EmptyView()
                        }
                    }
                } else {
                    // Default Placeholder Image
                    Image(systemName: "photo.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.gray)
                        .background(Color.gray.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .accessibilityHidden(true)
                }

                // Restaurant Details
                VStack(alignment: .leading, spacing: 5) {
                    Text(result.restaurant.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text(result.restaurant.address)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }

            Spacer()

            // Likes and Dislikes with Icons
            VStack(alignment: .trailing, spacing: 5) {
                HStack {
                    Image(systemName: "hand.thumbsup.fill")
                        .foregroundColor(.green)
                        .accessibilityHidden(true)
                    Text("\(result.likes)")
                        .font(.caption)
                        .foregroundColor(.primary)
                }
                HStack {
                    Image(systemName: "hand.thumbsdown.fill")
                        .foregroundColor(.red)
                        .accessibilityHidden(true)
                    Text("\(result.dislikes)")
                        .font(.caption)
                        .foregroundColor(.primary)
                }
            }
            .font(.caption)
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        .accessibilityElement(children: .combine)
        .padding(.horizontal)
    }
}

struct RestaurantResultRow_Previews: PreviewProvider {
    static var previews: some View {
        let sampleRestaurant = Restaurant(
            id: UUID(),
            name: "Sushi Place",
            address: "123 Main St",
            images: ["https://example.com/image.jpg"], // Replace with valid image URLs
            coordinate: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
            mapItem: MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)))
        )
        let sampleResult = RestaurantVoteResult(
            restaurant: sampleRestaurant,
            likes: 10,
            dislikes: 2
        )
        RestaurantResultRow(rank: 1, result: sampleResult)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
