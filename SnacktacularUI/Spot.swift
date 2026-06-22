//
//  Spot.swift
//  SnacktacularUI
//
//  Created by JIM WALEJKO on 6/18/26.
//

import Foundation
import FirebaseFirestore

struct Spot: Identifiable, Codable{
    @DocumentID var id: String?
    var name = ""
    var address = ""
}
