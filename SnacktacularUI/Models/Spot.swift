//
//  Spot.swift
//  SnacktacularUI
//
//  Created by JIM WALEJKO on 7/21/26.
//

import Foundation
import FirebaseFirestore
import CoreLocation
//import MapKit
//import Contacts

struct Spot: Identifiable, Codable, Equatable{
    @DocumentID var id: String?
    var name = ""
    var address = ""
    var latitude = 0.0
    var longitude = 0.0
    var coordinate: CLLocationCoordinate2D{
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var dictionary: [String: Any] {
        return["name": name, "address": addresss, "latitude": latitude, "longitude": longitude]
    }
}
