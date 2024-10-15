//
//  Vote.swift
//  Munch
//
//  Created by Mac Howe on 10/14/24.
//

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
