//
//  TableViewController.swift
//  Confirmed
//
//  Created by Sophie Miller on 6/8/18.
//  Copyright © 2018 Sophie Miller. All rights reserved.
//

import UIKit

import UIKit
import Firebase

@objc(AppointmentDetailTableViewController)
class AppointmentDetailTableViewController: UITableViewController, UITextFieldDelegate {
	
	let kSectionComments = 2
	let kSectionSend = 1
	let kSectionAppointment = 0
	
	var appointmentKey = ""

	let appointment: Appointment = Appointment()
	lazy var ref: DatabaseReference = Database.database().reference()
	var appointmentRef: DatabaseReference!
	var refHandle: DatabaseHandle?
	
	// UITextViewDelegate protocol method
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		appointmentRef = ref.child("appointments").child(appointmentKey)
		let nib = UINib(nibName: "AppointmentHistoryCell", bundle: nil)
		tableView.register(nib, forCellReuseIdentifier: "appointment")
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		.removeAll()
		// [START child_event_listener]
		// Listen for new comments in the Firebase database
		commentsRef.observe(.childAdded, with: { (snapshot) -> Void in
			self.comments.append(snapshot)
			self.tableView.insertRows(at: [IndexPath(row: self.comments.count-1, section: self.kSectionComments)], with: UITableViewRowAnimation.automatic)
		})
		// Listen for deleted comments in the Firebase database
		commentsRef.observe(.childRemoved, with: { (snapshot) -> Void in
			let index = self.indexOfMessage(snapshot)
			self.comments.remove(at: index)
			self.tableView.deleteRows(at: [IndexPath(row: index, section: self.kSectionComments)], with: UITableViewRowAnimation.automatic)
		})
		// [END child_event_listener]
		// [START appointment_value_event_listener]
		refHandle = appointmentRef.observe(DataEventType.value, with: { (snapshot) in
			let appointmentDict = snapshot.value as? [String : AnyObject] ?? [:]
			// [START_EXCLUDE]
			self.appointment.setValuesForKeys(appointmentDict)
			self.tableView.reloadData()
			self.navigationItem.title = self.appointment.title
			// [END_EXCLUDE]
		})
		// [END appointment_value_event_listener]
	}
	
	func indexOfMessage(_ snapshot: DataSnapshot) -> Int {
		var index = 0
		for  comment in self.comments {
			if snapshot.key == comment.key {
				return index
			}
			index += 1
		}
		return -1
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		if let refHandle = refHandle {
			appointmentRef.removeObserver(withHandle: refHandle)
		}
		commentsRef.removeAllObservers()
		if let uid = Auth.auth().currentUser?.uid {
			Database.database().reference().child("users").child(uid).removeAllObservers()
		}
	}
	
	// UITableViewDataSource protocol methods
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 3
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch section {
		case kSectionAppointment, kSectionSend:
			return 1
		default:
			return 0
		}
	}
	
	
	override func tableView(_ tableView: UITableView,
							cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell: UITableViewCell
		
		switch indexPath.section {
		case kSectionAppointment:
			cell = tableView.dequeueReusableCell(withIdentifier: "appointment", for: indexPath)
			if let uid = Auth.auth().currentUser?.uid {
				guard let appointmentcell = cell as? AppointmentHistoryCell else {
					break
				}
				let imageName = appointment.status == nil || appointment.stars![uid] == nil ? "ic_star_border" : "ic_star"
				appointmentcell.authorLabel.text = appointment.author
				appointmentcell.appointmentTitle.text = appointment.title
				appointmentcell.appointmentBody.text = appointment.body
				appointmentcell.starButton.setImage(UIImage(named: imageName), for: .normal)
				if let starCount = appointment.retainCount {
					appointmentcell.numStarsLabel.text = "\(starCount)"
				}
				appointmentcell.appointmentKey = appointmentKey
			}

	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if indexPath.section == kSectionAppointment {
			return 160
		}
		return 56
	}
}
