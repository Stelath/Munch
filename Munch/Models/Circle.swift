//
//  Circle.swift
//  Munch
//
//  Created by Alexander Korte on 7/26/24.
//

struct Circle: Identifiable, Codable {
    let id: String
    let code: String
    let name: String
    let location: String
    let users: [User]
    let restaurants: [Restaurant]?
    let started: Bool
}


struct Code: Identifiable, Codable {
    let id: String
    let code: String
    let circleId: String
}
