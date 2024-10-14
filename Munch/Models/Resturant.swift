//
//  Resturant.swift
//  Munch
//
//  Created by Alexander Korte on 6/17/24.
//

import Foundation
import CoreLocation
import MapKit

// TODO: Make Codeable and see what we need - mac
struct Restaurant: Identifiable {
    let id: UUID
    let name: String
    let address: String
    let images: [String]
    let coordinate: CLLocationCoordinate2D
    let mapItem: MKMapItem
}

//struct Restaurant: Identifiable, Codable {
//    let id: UUID
//    let name: String
//    let address: String
//    let imageURLs: [String]
//}

enum VoteType: String, Codable {
    case like
    case dislike
}

struct Vote: Codable {
    let id : String
    let restaurantId : String
    let userId : String
    let voteType : VoteType
}

struct RestaurantVoteResult: Codable {
    let restaurantId: UUID
    let likes: Int
    let dislikes: Int

    var score: Int {
        return likes - dislikes
    }
}
