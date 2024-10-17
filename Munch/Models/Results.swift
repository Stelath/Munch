//
//  Results.swift
//  Munch
//
//  Created by Mac Howe on 10/14/24.
//

import Foundation


struct RestaurantVoteResult: Identifiable, Codable {
    let id: String
    let restaurant: Restaurant
    let likes: Int
    let dislikes: Int

    var score: Int {
            let totalVotes = Float(likes + dislikes)
            guard totalVotes > 0 else { return 0 } 
            return Int((Float(likes) / totalVotes) * 100)
        }
}
