//
//  LocationManager.swift
//  LocationAndPlaceLookup
//
//  Created by JIM WALEJKO on 7/1/26.
//

import Foundation
import MapKit
import SwiftUI

@MainActor

class LocationManager: NSObject, ObservableObject{
    //  *** CRITICALLY IMPORTANT *** Always add info.plist message for Privacy - Location When in Use Usage Description
    @Published var location: CLLocation?
@Published var region = MKCoordinateRegion()
    

    
    
    override init(){
        super.init()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
    }
    }
    
    //  Get a region around current location with specified radius in meters
    func getRegionAroundCurrentLocation(radiusInMeters: CLLocationDistance = 10000) -> MKCoordinateRegion? {
        guard let location else { return nil }
        
        return MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: radiusInMeters,
            longitudinalMeters: radiusInMeters
        )
    }
}

//  Delegate methods that Apple has created & will call, but that we filled out
extension LocationManager{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else { return }  //  Use the last location as the location
        location = newLocation
        //  Call the callback function to indicate we've updated a location
        locationUpdated?(newLocation)
        
        //  You can uncomment this when you only want to get the location once, not repeatedly
        manager.stopUpdatingLocation()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            print("LocationManager authorization granted.")
            manager.startUpdatingLocation()
        case .denied, .restricted:
            print("LocationManager authorization denied.")
            errorMessage = "😡📍 LocationManager accessed denied."
            manager.stopUpdatingLocation()
        case .notDetermined:
            print("LocationManager authorization not determined.")
            manager.requestWhenInUseAuthorization()
        @unknown default :
            manager.requestWhenInUseAuthorization()
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        errorMessage = error.localizedDescription
        print("😡🗺️ ERROR LocationManager: \(errorMessage ?? "n/a")")
    }
}


