//
//  SpotViewModel.swift
//  SnacktacularUI
//
//  Created by JIM WALEJKO on 6/19/26.
//

import Foundation
import FirebaseFirestore

@Observable
class SpotViewModel{
    func saveSpot(spot: Spot) -> Bool{
        let db = Firestore.firestore()
        
        if let id = spot.id {  //  if true the spot exits
            do{
                try db.collection("spots").document(id).setData(from: spot)
                print("😎 Data updated successfully!")
                return true
            } catch {
                print("😡 Could not update data in 'spots' \(error.localizedDescription)")
                return false
            }
        }else {  //  We need to add a new spot & create a new id / document name
            do{
                try db.collection("spots").addDocument(from: spot)
                print("🐣 Data added successfully!")
                return true
            } catch{
                print(" Could not create a new spot in '[spots' \(error.localizedDescription)")
                return false
            }
        }
    }
}
