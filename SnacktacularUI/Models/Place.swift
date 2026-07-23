//
//  Place.swift
//  LocationAndPlaceLookup
//
//  Created by JIM WALEJKO on 7/2/26.
//

import Foundation
import MapKit
import Contacts

struct Place: Identifiable {
    let id = UUID().uuidString
    private var mapItem: MKMapItem
    
    init(mapItem: MKMapItem) {
        self.mapItem = mapItem
    }
    
}

var name: String {
    self.mapItem.name ?? ""
}

var address: String {
    let placemark = self.mapItem.placemark
    var cityAndState = ""
    var address = ""
}

cityAndState = placemark.locality ?? ""  //city
