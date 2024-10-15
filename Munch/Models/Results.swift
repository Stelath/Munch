//
//  Results.swift
//  Munch
//
//  Created by Mac Howe on 10/14/24.
//

import Foundation

// add codable back once restaurants is fixed
struct RestaurantVoteResult: Identifiable {
    let id: UUID = UUID()
    let restaurant: Restaurant
    let likes: Int
    let dislikes: Int
    
    var score: Int {
        return likes - dislikes
    }
}
