//
//  Spot.swift
//  SnacktacularUI
//
//  Created by JIM WALEJKO on 6/18/26.
//

import Foundation
import FirebaseFirestore
//import MapKit
//import Contacts

struct Spot: Identifiable, Codable{
    @DocumentID var id: String?
    var name = ""
    var address = ""
    var latitude = 0.0
    var longitude = 0.0
}

extension Spot{
    static var preview: Spot{
        let newSpot = Spot(id: "1", name: "Boston Public Market", address: "Boston, MA", latitude: 42.3601, longitude: -71.0589)
        return newSpot
    }
}
