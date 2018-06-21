//
//  AppointmentListViewController.swift
//  Confirmed
//
//  Created by Sophie Miller on 6/8/18.
//  Copyright © 2018 Sophie Miller. All rights reserved.
//

import UIKit
import FirebaseUI
import Firebase

class AppointmentListCell: UITableViewCell {
	
	@IBOutlet weak var profileImageView: UIImageView!
	var profileImage: UIImage?
	
	@IBOutlet weak var title: UILabel!
	@IBOutlet weak var specialty: UILabel!
	@IBOutlet weak var time: UILabel!
	@IBOutlet weak var status: UILabel!
	
	
	
	
}

class AppointmentListViewController: UIViewController, UITableViewDelegate {

	// [START define_database_reference]
	var ref: DatabaseReference!
	// [END define_database_reference]
	var dataSource: FUITableViewDataSource?
	
	@IBOutlet weak var tableView: UITableView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = "Test"
		
		// [START create_database_reference]
		ref = Database.database().reference()
		// [END create_database_reference]
		let identifier = "appointment"
		let nib = UINib(nibName: "AppointmentListCell", bundle: nil)
		tableView.register(nib, forCellReuseIdentifier: identifier)
		
		dataSource = FUITableViewDataSource(query: getQuery()) { (tableView, indexPath, snap) -> UITableViewCell in
			let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! AppointmentListCell
			
			guard let appointment = Appointment(snapshot: snap) else { return cell }
			cell.profileImage = UIImage(named: "ic_account_circle")
			cell.title.text = appointment.serviceProviderName
			cell.specialty.text = appointment.specialty
			cell.time.text = appointment.time
			cell.status.text = appointment.status
			
			return cell
		}
		
		dataSource?.bind(to: tableView)
		tableView.delegate = self
    }

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.tableView.reloadData()
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		performSegue(withIdentifier: "detail", sender: indexPath)
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 150
	}
	
	func getUid() -> String {
		return (Auth.auth().currentUser?.uid)!
	}
	
	func getQuery() -> DatabaseQuery {
		return self.ref
	}
	
	func refHandle() -> DatabaseHandle { return self.refHandle()
	}
	
	
	static func appointments(appointment: Appointment, completion: @escaping ([Appointment]) -> Void) {
		let ref = Database.database().reference().child("appointment")
		
		ref.observe(DataEventType.value, with: { (snapshot) in
			guard (snapshot.value as? [AppointmentDataSource]) != nil
				else{ return completion([]) }
			
		}) { (error) in
			print(error.localizedDescription)
		}
		
		ref.observeSingleEvent(of: .value, with: { (snapshot) in
			guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {
				return completion([])
			}
			
			let appointments = snapshot.reversed().compactMap(Appointment.init)
			completion(appointments)
		})

	}
	
//	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//		guard let indexPath: IndexPath = sender as? IndexPath else { return }
//		
//	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		getQuery().removeAllObservers()
	}
}
