//
//  User.swift
//  Munch
//
//  Created by Mac Howe on 10/14/24.
//

import Foundation

struct User: Identifiable, Codable, Equatable {
    let id: UUID
    let name: String
}
