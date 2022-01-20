//
//  FSCollectionReference.swift
//  SmartTable.
//
//  Created by macbook air on 19/1/22.
//

import Foundation
import FirebaseFirestore

enum FSCollectionReference: String {
  case UserProfile
}

//MARK: - Functions

func getFSCollectionReference(collectionReference: FSCollectionReference) -> CollectionReference {
  Firestore.firestore().collection(collectionReference.rawValue)
}
