//
//  Appointment.swift
//  Confirmed
//
//  Created by Sophie Miller on 12/9/17.
//

import Foundation
import UIKit
import Firebase

class Appointment: NSObject {
	
	var uid: String
    var appointmentID: String?
    var userID: String?
    var serviceProviderID: String
    var serviceProviderName: String
    var lat: Double
    var lng: Double
    var date: String
    var time: String
    var timeText: String
    var status: String
    var specialty: String
	
	init(uid: String, appointmentID: String, userID: String, serviceProviderID: String, serviceProviderName:String, lat: Double, lng: Double, date:String, time:String, timeText: String, status: String, specialty: String){
		self.uid = uid
		self.appointmentID = appointmentID
		self.date = date
		self.lat = lat
		self.lng = lng
		self.serviceProviderID = serviceProviderID
		self.serviceProviderName = serviceProviderName
		self.specialty = specialty
		self.status = status
		self.time = time
		self.timeText = timeText
	}
	
	init?(snapshot: DataSnapshot) {
		guard let dict = snapshot.value as? [String:Any] else { return nil }
		guard let uid  = dict["uid"] as? String  else { return nil }
		guard let appointmentID = dict["appointmentID"] as? String? else { return nil}
		guard let userID = dict["userID"] as? String else { return nil}
		guard let serviceProviderID = dict["serviceProviderID"] as? String else {return nil}
		guard let serviceProviderName = dict["serviceProviderName"] as? String else {return nil}
		guard let lat = dict["lat"] as? Double else {return nil}
		guard let lng = dict["lng"] as? Double else {return nil}
		guard let specialty = dict["specialty"] as? String else {return nil}
		guard let date = dict["date"] as? String else {return nil}
		guard let time = dict["time"] as? String else {return nil}
		guard let timeText = dict["timeText"] as? String else{return nil}
		guard let status = dict["status"] as? String else {return nil}
		
		
		self.uid = uid
		self.appointmentID = appointmentID
		self.userID = userID
		self.serviceProviderName = serviceProviderName
		self.serviceProviderID = serviceProviderID
		self.lat = lat
		self.lng = lng
		self.specialty = specialty
		self.date = date
		self.time = time
		self.timeText = timeText
		self.status = status
	}
	
	convenience override init() {
		self.init(uid: "", appointmentID: "", userID: "", serviceProviderID: "", serviceProviderName:"", lat: 0, lng: 0, date:"", time:"", timeText: "", status: "", specialty: "")
	}
    
}
