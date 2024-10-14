//
//  Endpoint.swift
//  Munch
//
//  Created by Mac Howe on 10/14/24.
//

import Foundation

enum Endpoint {
    case createCircle(name: String)
    case joinCircle(code: String)
    case startCircle(circleId: String)
    case fetchRestaurants(circleId: String)
//    case submitVote(circleId: String, restaurantId: String, vote: Vote)
    case getVotingResults(circleId: String)
    
    var url: URL {
        let baseUrl = "https://api.yourapp.com"
        switch self {
        case .createCircle(let name):
            return URL(string: "\(baseUrl)/circles?name=\(name)")!
        case .joinCircle(let code):
            return URL(string: "\(baseUrl)/circles/join?code=\(code)")!
        case .startCircle(let circleId):
            return URL(string: "\(baseUrl)/circles/\(circleId)/start")!
        case .fetchRestaurants(let circleId):
            return URL(string: "\(baseUrl)/circles/\(circleId)/restaurants")!
//        case .submitVote(let circleId, let restaurantId, let vote):
//            return URL(string: "\(baseUrl)/circles/\(circleId)/restaurants/\(restaurantId)/vote?vote=\(vote.rawValue)")!
        case .getVotingResults(let circleId):
            return URL(string: "\(baseUrl)/circles/\(circleId)/results")!
        }
    }
}
