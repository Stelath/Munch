//
//  User.swift
//  Munch
//
//  Created by Mac Howe on 10/14/24.
//

import Foundation

struct User: Identifiable, Codable, Equatable {
    let id: String // will be the apple user ID 
    let name: String
}
