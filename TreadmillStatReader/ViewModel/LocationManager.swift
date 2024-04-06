//
//  LocationManager.swift
//  TreadmillStatReader
//
//  Created by Rojin Prajapati on 4/4/24.
//

import Foundation
import CoreLocation
import HealthKit

class LocationDataManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    let locationDataManager = CLLocationManager()
    @Published var authorizationStatus: CLAuthorizationStatus?
    @Published var location: CLLocationCoordinate2D?
    @Published var distanceRunned: Double = 0.0
    var locationHistory: [CLLocation] = []
    var routeBuilder: HKWorkoutRouteBuilder?
    
    override init() {
        super.init()
        locationDataManager.delegate = self
        locationDataManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        //locationDataManager.distanceFilter = 5
        locationDataManager.allowsBackgroundLocationUpdates = true
        locationDataManager.pausesLocationUpdatesAutomatically = true
        locationDataManager.startUpdatingLocation()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:
            authorizationStatus = .authorizedWhenInUse
            locationDataManager.requestLocation()
            break
        case .restricted:
            authorizationStatus = .restricted
            break
        case .denied:
            authorizationStatus = .denied
            break
        case .notDetermined:
            authorizationStatus = .notDetermined
            locationDataManager.requestWhenInUseAuthorization()
            break
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Insert code to handle location updates
        //print(locations)
        let filteredLocations = locations.filter { (location: CLLocation) -> Bool in
            location.horizontalAccuracy <= 50.0
        }
        
        
        guard !filteredLocations.isEmpty else { return }
        print(locationHistory)
        /*
         find the start location
         add it to the locationHistory array
         distanceTravelled += filteredLocations.last.distance(from: locationHistory.last)
         */
        if locationHistory.isEmpty {
            if let newLocation = filteredLocations.last {
                locationHistory.append(newLocation)
            }
        }
        if let newLocation = filteredLocations.last {
            if let lastLocation = locationHistory.last {
                distanceRunned += newLocation.distance(from: lastLocation) / 1000
            }
            locationHistory.append(newLocation)
        }
        print("Distance Runned: \(distanceRunned)")
        
        routeBuilder?.insertRouteData(filteredLocations) { (success, error) in
            if !success {
                //Handle any errors here
                print("adding workout route data to routeBuilder failed")
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error: \(error.localizedDescription)")
    }
    
}
