//
//  ResturantViewModel.swift
//  Munch
//
//  Created by Alexander Korte on 6/17/24.
//

import Foundation
import Combine
import MapKit

class RestaurantViewModel: NSObject, ObservableObject {
    @Published var restaurants: [Restaurant] = []
    
    @Published var yesRestaurants: [String] = []
    @Published var noRestaurants: [String] = []
    
    private var locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    
//function for getting restaurants around the users location
    func fetchRestaurants(near location: CLLocation) {
//constant used for requesting information
        let request = MKLocalSearch.Request()
//look for restaurants
        request.naturalLanguageQuery = "restaurant"
//set region for the restaurant search
        request.region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 5000, longitudinalMeters: 5000)
//constant representing our search with parameters defined above
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard let response = response else { return }
//for the restaurants that we find store information about them
            DispatchQueue.main.async {
                self.restaurants = response.mapItems.map { item in
                    Restaurant(id: UUID(),
                               name: item.name ?? "Unknown",
                               address: item.placemark.title ?? "No Address",
                               coordinate: item.placemark.coordinate,
                               mapItem: item
                    )
                }
            }
        }
    }
}

extension RestaurantViewModel: CLLocationManagerDelegate {
//used to grab location permissions from user
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager.startUpdatingLocation()
        } else {
            print("Location permission denied")
        }
    }
//once we grab the restaurants stop using the users current location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            fetchRestaurants(near: location)
            locationManager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get user location: \(error.localizedDescription)")
    }
}
