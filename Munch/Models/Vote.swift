//
//  Vote.swift
//  Munch
//
//  Created by Mac Howe on 10/14/24.
//

import Foundation

enum VoteType: String, Codable {
    case like
    case dislike
}

struct Vote: Codable {
    let id : UUID
    let restaurantId : String
    let userId : String
    let voteType : VoteType
}
