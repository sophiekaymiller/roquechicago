//
//  Place.swift
//  Confirmed
//
//  Created by Sophie Miller on 12/8/17

import Foundation
import GooglePlaces
import Firebase

class Place: NSObject {
	
    var placeId: String
    var address: String
    var placeName: String
    var rating: Float
    var location: CLLocation?
    var status: String
    var distance: Float
    var website: String
    var timings: String
    var phoneNumber: String

	init(placeId: String, address: String, placeName: String, rating: Float, location: CLLocation, status: String, distance: Float, website: String, timings: String, phoneNumber: String){
	
	self.placeId = placeId
	self.address = address
	self.placeName = placeName
	self.rating = rating
	self.location = location
	self.status = status
	self.distance = distance
	self.website = website
	self.timings = timings
	self.phoneNumber = phoneNumber
		
	}
	
	init?(snapshot: DataSnapshot) {
		guard let dict = snapshot.value as? [String:Any] else {
			return nil
		}
		guard (dict["placeImage"] as? UIImage) != nil else {
			return nil
		}
		guard let placeId = dict["placeId"] as? String else{
			return nil
		}
		guard let address = dict["address"] as? String else{
			return nil
		}
		guard let placeName = dict["placeName"] as? String else{
			return nil
		}
		guard let rating = dict["rating"] else {
			return nil
		}
		guard let location = dict["location"] else {
			return nil
		}
		guard let status = dict["status"] else {
			return nil
		}
		guard  let distance = dict["distance"] as? Float else {
			return nil
		}
		guard let website = dict["website"] else {
			return nil
		}
		guard let timings = dict["timings"] else {
			return nil
		}
		guard let phoneNumber = dict["phoneNumber"] else {
			return nil
		}
		
		self.placeId = placeId
		self.address = address
		self.placeName = placeName
		self.rating = rating as! Float
		self.location = location as? CLLocation
		self.status = status as! String
		self.distance = distance
		self.website = website as! String
		self.timings = timings as! String
		self.phoneNumber = phoneNumber as! String
	}
	convenience override init() {
		self.init(placeId: "", address: "", placeName: "", rating: 0.0, location: CLLocation.init(), status: "", distance: 0.0, website: "", timings: "", phoneNumber: "")
	}
}

//struct Salon {
//	var salonId: String
//	var name: String
//	var address: [String]
//	var city: [String]
//	var state: [String]
//	var phone: String
//	var appointments: [Appointment]
//	var clients: [String]
//	var text: String
//
//
//	//var dictionary:
//	init(salonId: String, name: String, address: [String], city: [String], state: [String], phone: String, appointments:[Appointment], clients:[String], text: String ) {
//
//	}
//}

