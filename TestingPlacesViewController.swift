//
//  TestingPlacesViewController.swift
//  Confirmed
//
//  Created by Sophie Miller on 6/3/18.
//  Copyright © 2018 sophieMiller. All rights reserved.
//

import UIKit
import GooglePlaces
import GooglePlacePicker
import FirebaseDatabase
import FirebaseUI

class TestingPlacesViewController: UIViewController {

	let placesClient = GMSPlacesClient.shared()
	
	@IBOutlet weak var placeName: UILabel!
	@IBOutlet weak var placeAddress: UILabel!
	
	var db = Database.database()
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		db.isPersistenceEnabled = true
		
		getPlaceDetails()

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	
	func getPlaceDetails() {

		let placeID = "ChIJHz5Xo7IsDogRJwUX_bsudls"
		//let place = GMSPlace()
		
		placesClient.lookUpPlaceID(placeID, callback: { (place, error)->
			Void in
			if error != nil {
				print("lookup place id query error\(error?.localizedDescription ?? "Query Error")")
			}
			guard let place = place else {
				print("no place found")
				return
			}
			print("Place name \(place.name)")
			print("\(String(describing: place.formattedAddress))")
			
			self.placeName.text = place.name
			self.placeAddress.text = place.formattedAddress
			
			self.db.reference().child("Salon").setValuesForKeys(["name": self.placeName.text ?? "no name found"])
		})
	}
}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


