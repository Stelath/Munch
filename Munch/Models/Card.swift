//
//  Card.swift
//  Munch
//
//  Created by Alexander Korte on 6/17/24.
//


//
//  Person.swift
//  TinderClone
//
//  Created by Franck-Stephane Ndame Mpouli on 06/08/2020.
//

import UIKit
import CoreLocation
import MapKit

//MARK: - DATA
struct Card: Identifiable {
    let id = UUID()
    let name: String
    let about: String
    let coordinate: CLLocationCoordinate2D
    let mapItem: MKMapItem
    
    var x: CGFloat = 0.0
    var y: CGFloat = 0.0
    var degree: Double = 0.0
}
