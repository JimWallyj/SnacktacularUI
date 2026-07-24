//
//  SpotViewModel.swift
//  SnacktacularUI
//
//  Created by JIM WALEJKO on 6/19/26.
//

import Foundation
import FirebaseFirestore
import UIKit
import FirebaseStorage


@MainActor

class SpotViewModel: ObservableObject{
    @Published var spot = Spot()
    
    func saveSpot(spot: Spot) async -> Bool {  //  nil if effort failed, otherwise return spot.id
        let db = Firestore.firestore()  //  ignore any error that shows up here.  Wait for indexing.  Clean build if it persists with shift+command+K. Error usually goes away with build + run. Otherwise try restarting Mac/Xcode and deleting derived data. For instructions on derived data deletion, see: https://deriveddata.dance
        
        if let id = spot.id {  //  if true the spot exits, so save
            do{
                try await db.collection("spots").document(id).setData(spot.dictionary)
                print("😎 Data updated successfully!")
                return true
            } catch {
                print("😡 ERROR: Could not update data in 'spots' \(error.localizedDescription)")
                return false
            }
        }else {  //  We need to add a new spot & create a new id / document name
            do{
                let documentRef = try await db.collection("spots").addDocument(data: spot.dictionary)
                self.spot = spot
                self.spot.id = documentRef.documentID
                print("🐣 Data added successfully!")
                return true
            } catch{
                print("😡 ERROR: Could not create a new spot in 'spots' \(error.localizedDescription)")
                return false
            }
        }
    }
   
}
