//
//  FirebaseHelper.swift
//  Confirmed
//
//  Created by Sophie Miller on 12/9/17.
//  Copyright © 2017 Confirmed. All rights reserved.
//

import Foundation
import FirebaseDatabase
import GooglePlacePicker
import GooglePlaces
import GoogleMaps


public class FirebaseHelper: NSObject {
	
	static let db = Database.database()
	
    static let rootRef = db.reference()
	
	static let collectionRef = db.reference(withPath: "collections")
	
	static let placesRef = db.reference(withPath: "places")
    
    static func save(child: String!, value: NSDictionary!) {
        print("FirebaseHelper: ", "Save");
        rootRef.child(child).setValue(value);
    }
    
    static func save(child: String!, uid: String!, value: NSDictionary!) {
        rootRef.child(child).child(uid).setValue(value);
    }
    
    static func delete(child: String!){
        rootRef.child(child).removeValue()
    }
	

}

//class DatabaseWrapper {
//	private let collectionRef: FIRDatabaseReference
//	private let placesRef: FIRDatabaseReference
//	
//	let database = FIRDatabase.database()
//	
//	private init() {
//		// Create a reference to the collections Firebase DB (get the list of place collection titles).
//		collectionRef = database.reference(withPath: "collections")
//		
//		// Create a reference to the places Firebase DB (get the list of places in a collection).
//		placesRef = database.reference(withPath: "places")
//	}
//
//	static func observeCollections(changeHandler: @escaping ([PlaceCollection]) -> ()) {
//				collectionRef.observe(.value, with: { snapshot in
//					var newItems: [PlaceCollection] = []
//					for item in snapshot.children {
//						let collectionItem = PlaceCollection(snapshot: item as! DataSnapshot)
//						newItems.append(collectionItem)
//					}
//
//					changeHandler(newItems)
//				})
//			}


//	func observeCollections(changeHandler: @escaping ([PlaceCollection]) -> ()) {
//		collectionRef.observe(.value, with: { snapshot in
//			var newItems: [PlaceCollection] = []
//			for item in snapshot.children {
//				let collectionItem = PlaceCollection(snapshot: item as! DataSnapshot)
//				newItems.append(collectionItem)
//			}
//			
//			changeHandler(newItems)
//		})
//	}
//	
//	DatabaseWrapper.sharedInstance.observeCollections { newCollections in
//	self.items = newCollections
//	self.collectionTable.reloadData()
//	}
//
//}
