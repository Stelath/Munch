//
//  RoomAction.swift
//  Munch
//
//  Created by Alexander Korte on 6/16/24.
//

import Foundation

enum RoomAction: String, CaseIterable, Identifiable {
    case joinRoom = "Join Room"
    case createRoom = "Create Room"
    var id: Self { self }
}
