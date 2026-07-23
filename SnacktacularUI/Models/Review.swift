//
//  Review.swift
//  SnacktacularUI
//
//  Created by JIM WALEJKO on 7/12/26.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseAuth

struct Review: Identifiable, Codable{
    @DocumentID var id: String?
    var title = ""
    var body = ""
    var rating = 0
    var reviewer = Auth.auth().currentUser?.email ?? ""
    var postedOn = Date()
    
   var dictionary: [String: Any] {
        return ["title": title, "body": body, "rating": rating, "reviewer": reviewer, "postedOn": Timestamp(date: Date())]
    }
}





