//
//  Card.swift
//  Munch
//
//  Created by Alexander Korte on 6/17/24.
//


import Foundation
import CoreLocation
import MapKit


struct Card: Identifiable {
    let id = UUID()
    let name: String
    let about: String
    let coordinate: CLLocationCoordinate2D
    let mapItem: MKMapItem
    

}
