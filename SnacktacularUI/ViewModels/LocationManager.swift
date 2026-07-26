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
    
private let locationManager = CLLocationManager()
    
    override init(){
        super.init()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()  //  Remember to update Info.plist!
        locationManager.delegate = self
    }
}

//  Delegate methods that Apple has created & will call, but that we filled out
extension LocationManager: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }  //  Use the last location as the location
        self.location = location
        self.region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 5000, longitudinalMeters: 5000)
    }
}

