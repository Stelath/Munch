//
//  Resturant.swift
//  Munch
//
//  Created by Alexander Korte on 6/17/24.
//

import Foundation
import CoreLocation
import MapKit

struct Restaurant: Identifiable {
    let id: UUID
    let name: String
    let address: String
    let coordinate: CLLocationCoordinate2D
    let mapItem: MKMapItem
}