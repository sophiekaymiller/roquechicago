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

class AppointmentListViewController: UIViewController, UITableViewDelegate {

	// [START define_database_reference]
	var ref: DatabaseReference!
	// [END define_database_reference]
	var dataSource: FUITableViewDataSource?
	
	@IBOutlet weak var tableView: UITableView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// [START create_database_reference]
		ref = Database.database().reference()
		// [END create_database_reference]
		let identifier = "appointment"
		let nib = UINib(nibName: "AppointmentHistoryCell", bundle: nil)
		tableView.register(nib, forCellReuseIdentifier: identifier)
		
		dataSource = FUITableViewDataSource(query: getQuery()) { (tableView, indexPath, snap) -> UITableViewCell in
			let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! AppointmentHistoryCell
			
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
	
//	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//		guard let indexPath: IndexPath = sender as? IndexPath else { return }
//		
//	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		getQuery().removeAllObservers()
	}
}
