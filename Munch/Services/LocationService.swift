import Foundation
import CoreLocation

class LocationService: NSObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    private var locationContinuation: CheckedContinuation<CLLocation, Error>?
    private var authorizationContinuation: CheckedContinuation<Void, Error>?
    
    // Timeout duration for location requests
    private let locationTimeout: TimeInterval = 15
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    /// Requests the user's current location. Handles authorization if needed.
    /// - Returns: The user's current location
    /// - Throws: LocationError if permission is denied or location cannot be determined
    func getCurrentLocation() async throws -> CLLocation {
        let status = locationManager.authorizationStatus
        
        switch status {
        case .notDetermined:
            try await requestAuthorization()
            
        case .denied, .restricted:
            throw LocationError.permissionDenied
            
        case .authorizedWhenInUse, .authorizedAlways:
            break
            
        @unknown default:
            throw LocationError.unknownStatus
        }
        
        // Request location with timeout
        return try await withThrowingTaskGroup(of: CLLocation.self) { group in
            // location request task
            group.addTask {
                return try await withCheckedThrowingContinuation { continuation in
                    self.locationContinuation = continuation
                    self.locationManager.requestLocation()
                }
            }
            
            // task timeout
            group.addTask {
                try await Task.sleep(nanoseconds: UInt64(self.locationTimeout * 1_000_000_000))
                throw LocationError.timeout
            }
            
            // Wait for the first task to complete
            do {
                // Get the first result and cancel other tasks
                for try await location in group {
                    group.cancelAll()
                    return location
                }
                throw LocationError.noLocation
            } catch {
                group.cancelAll()
                throw error
            }
        }
    }
    
    /// Request location authorization from the user
    private func requestAuthorization() async throws {
        return try await withCheckedThrowingContinuation { continuation in
            self.authorizationContinuation = continuation
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    // MARK: - CLLocationManagerDelegate Methods
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            authorizationContinuation?.resume()
        case .denied, .restricted:
            authorizationContinuation?.resume(throwing: LocationError.permissionDenied)
        case .notDetermined:
            // Wait for definitive answer
            break
        @unknown default:
            authorizationContinuation?.resume(throwing: LocationError.unknownStatus)
        }
        authorizationContinuation = nil
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            locationContinuation?.resume(throwing: LocationError.noLocation)
            locationContinuation = nil
            return
        }
        
        locationContinuation?.resume(returning: location)
        locationContinuation = nil
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let error = error as? CLError {
            locationContinuation?.resume(throwing: LocationError.clError(error))
        } else {
            locationContinuation?.resume(throwing: error)
        }
        locationContinuation = nil
    }
}

// MARK: - LocationError

enum LocationError: LocalizedError {
    case permissionDenied
    case unknownStatus
    case timeout
    case noLocation
    case unknown
    case clError(CLError)
    
    var errorDescription: String? {
        switch self {
        case .permissionDenied:
            return "Location permission was denied. Please enable it in settings."
        case .unknownStatus:
            return "An unknown location authorization status was encountered."
        case .timeout:
            return "Location request timed out."
        case .noLocation:
            return "No location data was received."
        case .unknown:
            return "An unknown error occurred while requesting location."
        case .clError(let error):
            return "CoreLocation error: \(error.localizedDescription)"
        }
    }
}
