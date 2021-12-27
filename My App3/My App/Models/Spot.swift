//
//  Spot.swift
//  My App
//
//  Created by macbook air on 22/05/1443 AH.
//

import Foundation
import Firebase

class Spot {
  var name: String
  var address: String
  var averageRating: Double
  var numberOfReviews: Int
  var postingUserID: String
  var documentID: String
  
  var dictionray: [String: Any] {
    return ["name": name, "address": address, "averageRating": averageRating, "numberOfReviews": numberOfReviews, "postingUserID":postingUserID]
  }
  
  init(name: String, address: String, averageRating:Double, numberOfReviews: Int, postingUserID: String, documentID: String) {
    
    self.name = name
    self.address = address
    self.averageRating = averageRating
    self.numberOfReviews = numberOfReviews
    self.postingUserID = postingUserID
    self.documentID = documentID
    
  }
  
  convenience init(){
    
    self.init(name: "", address: "", averageRating: 0.0, numberOfReviews: 0, postingUserID: "", documentID: "")
  }
  
  
  func saveData(completion: @escaping (Bool) -> ()) {
    let db = Firestore.firestore()
    
    guard let postingUserID = Auth.auth().currentUser?.uid else {
      print("😡 Error: Could not save data because we don't have a vaild postingUserID ")
      return completion(false)
    }
    self.postingUserID = postingUserID
    
    let dataToSave: [String: Any] = self.dictionray
    
    if self.documentID == "" {
      var ref: DocumentReference? = nil
      ref = db.collection("spots").addDocument(data: dataToSave){ (error) in
        guard error == nil else{
          print("😡 Error: adding document \(error!.localizedDescription)")
          return completion(false)
        }
        
        self.documentID = ref!.documentID
        print("💨Added document: \(self.documentID)")
        completion(true)
      }
      
    } else {
      let ref = db.collection("spots").document(self.documentID)
      ref.setData(dataToSave) { (error) in
        guard error == nil else{
          print("😡 Error: adding document \(error!.localizedDescription)")
          return completion(false)
        }
        print("💨Updated document: \(self.documentID)")
        completion(true)
      }
    }
  }
}
