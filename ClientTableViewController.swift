//
//  ClientDetailTVC.swift
//  Appt
//
//  Created by Sophie Miller on 6/21/17.
//  Copyright © 2017 SophieMiller. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI


class ClientDetailTVC: UITableViewController {
	
	var client: User.client
	
	var appointmentsForClient: [Appointment]?
	private let segueEditClient = "SegueEditClient"
	private let segueAppts = "AppointmentForClient"
	
	// Load Appointments for given date
	lazy var ref = Database.database().reference()
	lazy var apptArray = FUIArray.init(query: ref)

	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var mobilePhoneLabel: UILabel!
	@IBOutlet weak var homePhoneLabel: UILabel!
	@IBOutlet weak var emailLabel: UILabel!
	
	@IBAction func editClient(_ sender: UIButton) {
		performSegue(withIdentifier: segueEditClient, sender: self)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		Database.database().isPersistenceEnabled = true
		
		noLargeTitles()
		checkAppointments()
		
	}
	
	override func viewWillAppear(_ animated: Bool) {
		setupUI()
	}
	
	
	
	func noLargeTitles(){
		if #available(iOS 11.0, *) {
			navigationItem.largeTitleDisplayMode = .never
			tableView.dragDelegate = self as? UITableViewDragDelegate
		}
	}
	
	func setupUI() {
		guard let client = client else { return }
		nameLabel.text = client.fullName
		
		if client.mobilePhone != nil {
			mobilePhoneLabel.text = client.mobilePhone
		}
		if client.homePhone != nil {
			homePhoneLabel.text = client.homePhone
		}
		if client.email != nil {
			emailLabel.text = client.email
		}
		
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == segueEditClient {
			if let destinationNavigationViewController = segue.destination as? UINavigationController {
				// Configure View Controller
				let targetController = destinationNavigationViewController.topViewController as! NewClientTableVC
				targetController.client = client
			}
		} else if segue.identifier == segueAppts {
			if let destinationNavigationVC = segue.destination as? ApptsForClientContainerView {
				if let selectedClient = client {
					destinationNavigationVC.client = selectedClient
				}
			}
		}
	}
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		
		switch indexPath.section {
		case 0:
			if indexPath.row == 0 { return 272 }
		case 1:
			switch indexPath.row {
			case 0:
				if appointmentsForClient?.count != 0 { return 200 }
				else { return 0.0 }
			case 1:
				if appointmentsForClient?.count != 0 { return 0 }
				else { return 80 }
			case 2:
				return 80
			default:
				return UITableViewAutomaticDimension
			}
		default:
			return UITableViewAutomaticDimension
		}
		return UITableViewAutomaticDimension
		
	}
	
	
	//  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
	//    let cell = UITableViewCell()
	//    if indexPath.section == 0 {
	//      if indexPath.row == 0 {
	//
	//      }
	//    } else if indexPath.section == 1 {
	//      let cell = tableView.dequeueReusableCell(withIdentifier: "ClientAppointmentCell", for: indexPath) as! ClientAppointmentCell
	//      if let appointments = appointmentsForClient {
	//        let appointment = appointments[indexPath.row]
	//
	//        cell.dateLabel.text = shortDateFormatter( date: appointment.date)
	//        if let note = appointment.note {
	//          cell.noteLabel.text = note
	//        } else {
	//          cell.noteLabel.text = "There isn't any note for appointment with \(appointment.client.fullName)"
	//        }
	//      }
	//      return cell
	//    }
	//    return cell
	//  }
	
	
}


extension ClientDetailTVC {
	
	func checkAppointments() {
		fetchAppointmentsForClient()
		
		if let fetchedAppointments = fetchedResultsController.fetchedObjects {
			appointmentsForClient = fetchedAppointments
			//      print(appointmentsForClient)
		} else {
			print("Clients has no appointments")
		}
	}
	
	func fetchAppointmentsForClient() {
		do {
			try self.fetchedResultsController.performFetch()
			print("AppointmentForDay Fetch Successful")
		} catch {
			let fetchError = error as NSError
			print("Unable to Perform AppointmentForDay Fetch Request")
			print("\(fetchError), \(fetchError.localizedDescription)")
		}
	}
}

extension ClientDetailTVC: NSFetchedResultsControllerDelegate {
	
	func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		tableView.beginUpdates()
	}
	
	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		tableView.endUpdates()
	}
	
	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
		switch (type) {
		case .insert:
			if let indexPath = newIndexPath {
				print("Appt Added")
				tableView.insertRows(at: [indexPath], with: .fade)
			}
			break;
		case .delete:
			print("Appt Deleted")
			if let indexPath = indexPath {
				tableView.deleteRows(at: [indexPath], with: .fade)
			}
			break;
		case .update:
			if let indexPath = indexPath {
				print("Appt Changed and updated")
				tableView.reloadRows(at: [indexPath], with: .fade)
			}
		default:
			print("...")
		}
	}
	
	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
	}
}

