//
//  Photo.swift
//  SnacktacularUI
//
//  Created by JIM WALEJKO on 6/26/26.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseAuth


class Photo: Identifiable, Codable {
    @DocumentID var id: String?
    var imageURLString = ""  //  This will hold the URL for loading the image
    var description = ""
    var reviewer = Auth.auth().currentUser?.email ?? ""
    var postedOn = Date()  //  current date/time
    
    var dictionary: [String: Any]{
        return ["imageURLString": imageURLString, "description": description, "reviewer": reviewer, "postedOn": Timestamp(date: Date())]
    }
 
}

