//
//  LocationService.swift
//  Munch
//
//  Created by Mac Howe on 10/13/24.
//

import Foundation
import CoreLocation
import Combine

class LocationService: NSObject, ObservableObject {
    @Published var currentLocation: CLLocation?
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var locationError: Error?
    
    private let locationManager = CLLocationManager()
    private var lastClientLocation: CLLocation?

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
    }

    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
}

extension LocationService: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        switch authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            startUpdatingLocation()
        case .denied, .restricted:
            locationError = NSError(domain: "LocationPermission", code: 1, userInfo: [NSLocalizedDescriptionKey: "Location permission denied"])
        case .notDetermined:
            requestLocationPermission()
        @unknown default:
            locationError = NSError(domain: "LocationPermission", code: 2, userInfo: [NSLocalizedDescriptionKey: "Unknown authorization status"])
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        if let lastLocation = lastClientLocation, location.distance(from: lastLocation) < 50 {
            print("Location update ignored: not significant enough.")
            return
        }
        lastClientLocation = location
        currentLocation = location
        locationManager.stopUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationError = error
    }
}
