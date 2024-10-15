//
//  Resturant.swift
//  Munch
//
//  Created by Alexander Korte on 6/17/24.
//

import Foundation
import CoreLocation
import MapKit

// TODO: Make Codeable and see what we need - mac
struct Restaurant: Identifiable {
    let id: UUID
    let name: String
    let address: String
    let images: [String]
    let coordinate: CLLocationCoordinate2D
    let mapItem: MKMapItem
}

//struct Restaurant: Identifiable, Codable {
//    let id: UUID
//    let name: String
//    let address: String
//    let imageURLs: [String]
//    let logoURL: String?
//    
//}

