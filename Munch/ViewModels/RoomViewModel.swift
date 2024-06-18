//
//  RoomViewModel.swift
//  Munch
//
//  Created by Alexander Korte on 6/16/24.
//

import Foundation

class RoomViewModel: ObservableObject {
    @Published var selectedRoomAction: String = RoomAction.joinRoom.rawValue
    
    // MARK: Join Room
    @Published var roomCode: String = ""
    func joinRoom() {
        
    }
    
    // MARK: Create Room
    
}
