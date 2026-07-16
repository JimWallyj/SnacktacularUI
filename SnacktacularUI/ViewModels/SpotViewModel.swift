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
    
    static func saveSpot(spot: Spot) async -> String? {  //  nil if effort failed, otherwise return spot.id
        let db = Firestore.firestore()
        
        if let id = spot.id {  //  if true the spot exits
            do{
                try db.collection("spots").document(id).setData(from: spot)
                print("😎 Data updated successfully!")
                return id
            } catch {
                print("😡 Could not update data in 'spots' \(error.localizedDescription)")
                return id
            }
        }else {  //  We need to add a new spot & create a new id / document name
            do{
                let docRef = try db.collection("spots").addDocument(from: spot)
                print("🐣 Data added successfully!")
                return docRef.documentID
            } catch{
                print(" Could not create a new spot in '[spots' \(error.localizedDescription)")
                return nil
            }
        }
    }
    static func deleteSpot(spot: Spot){
        let db = Firestore.firestore()
        guard let id = spot.id else{
            print("No spot.id")
            return
        }
        Task{
            do{
                try await db.collection("spots").document(id).delete()
            }catch{
                print("😡 ERROR Could not delete document \(id).  \(error.localizedDescription)")
            }
        }
    }
}
