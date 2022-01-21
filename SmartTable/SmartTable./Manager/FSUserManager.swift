//
//  FSUserManager.swift
//  SmartTable.
//
//  Created by macbook air on 19/1/22.
//

import Foundation
import Firebase

class FSUserManager {
  
  //MARK: - Properties

  static let shared = FSUserManager()
  
  private init() {}
  
  //MARK: - Register

  func signUpUserWith(
    email: String,
    password: String,
    name: String,
    confirmPassword: String,
    completion: @escaping (_ error: Error?) -> Void
  ) {
   
    Auth.auth().createUser(withEmail: email,
                           password: password) { authDataResult, error in
      completion(error)
      
      if let error = error as NSError? {
        completion(error)
      } else {
        guard let user = authDataResult?.user else {
          return
        }
        
        getFSCollectionReference(collectionReference: .UserProfile)
          .document(user.uid)
          .setData([
          "name": name,
          "email": email,
          "userID": user.uid,
        ], merge: true) { error in
          if let _ = error {
//            print("DEBUG: Error writing document: \(err.localizedDescription)")
            completion(error)
          } else {
            print("DEBUG: \(#function) - Document successfully written!")
          }
        }
      }
    }
    
  }
  
}
