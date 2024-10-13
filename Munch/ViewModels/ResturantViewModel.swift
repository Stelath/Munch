//
//  ResturantViewModel.swift
//  Munch
//
//  Created by Alexander Korte on 6/17/24.
//

import Foundation
import Combine
import MapKit

public enum SwipeDirection {
    case left
    case right
}

class RestaurantViewModel: NSObject, ObservableObject {
    @Published var restaurants: [Restaurant] = []
    @Published var cards: [Card] = []
    @Published var currentCardIndex: Int = 0
    
    @Published var yesRestaurants: [Card] = []
    @Published var noRestaurants: [Card] = []
    
    private var locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    
    var isAllRestaurantsSwiped: Bool {
        return restaurants.count == (yesRestaurants.count + noRestaurants.count)
    }
    
    // Function for getting restaurants around the users location
    func fetchRestaurants(near location: CLLocation) {
        // Constant used for requesting information
        let request = MKLocalSearch.Request()
        // Look for restaurants & set region for the resturant search
        request.naturalLanguageQuery = "restaurant"
        request.region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 5000, longitudinalMeters: 5000)
        
        // Search nearby for resturants
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
                
                self.updateCards()
            }
        }
    }
    func updateCards() {
        self.cards.removeAll()
        self.cards = restaurants.map { restaurant in
            Card(name: restaurant.name, about: "", coordinate: restaurant.coordinate, mapItem: restaurant.mapItem)
        }
        
        self.currentCardIndex = self.cards.count - 1
    }
    
    // Unified method to handle swipes
    func handleSwipe(direction: SwipeDirection, moveCard: Bool = false) {
        guard currentCardIndex >= 0 else { return }
        
        if moveCard {
            self.cards[currentCardIndex].x = direction == .left ? -500 : 500
            self.cards[currentCardIndex].degree = direction == .left ? -12 : 12
            
        }
        
        if direction == .left {
            self.noRestaurants.append(self.cards[currentCardIndex])
        } else {
            self.yesRestaurants.append(self.cards[currentCardIndex])
        }
        
//        self.cards.remove(at: currentCardIndex)
        self.currentCardIndex -= 1
    }
    
    
}

extension RestaurantViewModel: CLLocationManagerDelegate {
    // Grab location permissions from users
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager.startUpdatingLocation()
        } else {
            print("Location permission denied")
        }
    }
    
    // Once we grab the restaurants stop using the users current location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let tempLocation = CLLocation(latitude:34.681951192984215, longitude:-82.83710411475863)
            fetchRestaurants(near: tempLocation)
            locationManager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get user location: \(error.localizedDescription)")
    }
}
