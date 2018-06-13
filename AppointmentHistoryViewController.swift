//
//  AppointmentHistoryViewController.swift
//  Confirmed
//
//  Created by Sophie Miller on 11/20/17.
//  Copyright © 2017 Confirmed. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI
import FirebaseDatabase

class AppointmentHistoryCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var specialty: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var status: UILabel!
	@IBOutlet weak var profileImage: UIImage!
    
}

class AppointmentHistoryViewController: UITableViewController {

	let kSectionComments = 2
	let kSectionSend = 1
	let kSectionPost = 0
	
    var cellIdentifier = "AppointmentHistoryCell"
    var sectionTitle: [String] = ["Upcoming", "Past"]
	var appointmentData: Array<DataSnapshot> = []
	var db: Database!
	var appointment = Appointment()

	lazy var ref: DatabaseReference = Database.database().reference()
	var appointmentRef: DatabaseReference!
	var refHandle: DatabaseHandle?
	
	//var User: User!
	//var Auth: Auth!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Appointments"
		db = Database.database()
		
		appointmentRef = ref.child("appointment").childByAutoId()
		
		let nib = UINib(nibName: "AppointmentTableViewCell", bundle: nil)
		tableView.register(nib, forCellReuseIdentifier: "appointment")

		let doneBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 44))
		doneBar.autoresizingMask = .flexibleWidth
		let flex = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
		let done = UIBarButtonItem(title: "Appointments", style: .plain, target: self, action: #selector(didTapShare))
		done.tintColor = UIColor(red: 1.0, green: 143.0/255.0, blue: 0.0, alpha: 1.0)
		doneBar.items  = [flex, done, flex]
		doneBar.sizeToFit()

		getData()


    }

	//TO DO.
	@IBAction func didTapShare(_ sender: AnyObject) {
		// [START single_value_read]
		let userID = Auth.auth().currentUser?.uid
		ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
			// Get user value

			
		}) { (error) in
			print(error.localizedDescription)
		}
		// [END single_value_read]
	}

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

		appointmentData.removeAll()
		// [START child_event_listener]
		// Listen for new comments in the Firebase database
		appointmentRef.observe(.childAdded, with: { (snapshot) -> Void in
			self.appointmentData.append(snapshot)
			self.tableView.insertRows(at: [IndexPath(row: self.appointmentData.count-1, section: self.kSectionComments)], with: UITableViewRowAnimation.automatic)
		})
		
		// Listen for deleted comments in the Firebase database
		appointmentRef.observe(.childRemoved, with: { (snapshot) -> Void in
			let index = self.indexedAppointments(snapshot)
			self.appointmentData.remove(at: index)
			self.tableView.deleteRows(at: [IndexPath(row: index, section: self.kSectionComments)], with: UITableViewRowAnimation.automatic)
		})

		refHandle = appointmentRef.observe(DataEventType.value, with: { (snapshot) in
			let appointmentDictionary = snapshot.value as? [String : AnyObject] ?? [:]
				// [START_EXCLUDE]
			self.appointmentRef.setValuesForKeys(appointmentDictionary)
			self.tableView.reloadData()
			self.navigationItem.title = self.appointment.date
			
				// [END_EXCLUDE]
			})
//		let rootRef = db.reference()
//		rootRef.child("appointment").observe(.value, with: { snapshot in
//			if(snapshot.exists()) {
//            let results = snapshot.value as? NSDictionary
//
//            var appointments = [Appointment]()
//
//				for (_, value) in results!{
//
//				appointment.serviceProviderName = results![appointments] as! String
//				appointment.serviceProviderID = results!["serviceProviderID"] as? String
//				appointment.date = results["date"] as? String
//				appointment.time = results["time"] as? String
//				appointment.lat = result["lat"] as? Double
//				appointment.lng = result["long"] as? Double
//				appointment.specialty = result["value"] as? String
//                appointment.userID = result["userID"] as? String
//                appointment.appointmentID = result
//
//
//				let bookRef = rootRef.child("bookings").child(appointment.serviceProviderID).child(appointment.date).child(appointment.time)
////				rootRef.child("bookings").child(appointment.serviceProviderID).child(appointment.date).child(appointment.time)
//
//                bookRef.observe(.value, with: { snapshot in
//                    if(snapshot.exists()) {
//						let booking =  (snapshot.value as! NSDictionary)
//						appointment.status = (booking.value(forKey: "status") as? String)!
//						print(appointment.status )
//                        self.tableView.reloadData()
//                    }
//                })
//
//                appointment.timeText = "On " + appointments[].date + " at " + appointments[].time
//
//                appointments.append(appointment)
//            }
//            self.appointmentData = appointments
//
//            print("--->>>>", appointments.count)
//            }
//        })
//
//    	}
	}

	func indexedAppointments(_ snapshot: DataSnapshot) -> Int {
		var index = 0
		for  appointment in appointmentData {
			if snapshot.key == appointment.key {
				return index
			}
			index += 1
		}
		return -1
	}

	func getData(){
		let user = Auth.auth().currentUser
		if let user = user {
			let uid = user.uid
//			let email = user.email
//			let photo = user.photoURL

		ref = db.reference()

		ref.child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
			_ = snapshot.value as? NSDictionary
		})
		{ (error) in
				print(error.localizedDescription)
		}
		return
	}
}

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitle[section]
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if( section == 0) {
			return self.appointmentData.count
        }
        else {
            return 0
        }
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! AppointmentHistoryCell

        if indexPath.section == 1 {
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.selectionStyle = UITableViewCellSelectionStyle.gray
            cell.isUserInteractionEnabled = false
        }
		
        // Configure the cell...
       // let row = appointmentData[indexPath.row]
		
        cell.title.text = appointment.serviceProviderName
        cell.status.text = appointment.status
        cell.time.text = appointment.timeText
		cell.specialty.text = appointment.specialty

        return cell
    }

@IBAction func testSetData(){
	
	appointment = Appointment(uid:"\(Auth.auth().currentUser?.uid ?? "")", appointmentID: "2", userID: "\(appointment.uid)", serviceProviderID: "Roque Salon", serviceProviderName: "Melinda", lat: 0.0, lng: 0.0, date: ("\(Date.init())"), time: "\(Date.init(timeIntervalSinceNow: 15))", timeText: "", status: "pending", specialty: "Haircut")
	
	appointmentRef.setValue(appointment)
	
	}
}

////To be implemented. 6-5-18
//
//	@IBAction func addAppointment(_ sender: UIBarButtonItem) {
//
//		let add = UITableViewRowAction(style: .normal, title: "add") { action, index in
//			print("add button tapped", index) }
//
//		add.backgroundColor = UIColor.green
//
//		performSegue(withIdentifier: "addAppointment", sender: self)
//	}
//
//    // Add swipe gesture to table view cells
//    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//
//
//        let edit = UITableViewRowAction(style: .normal, title: "Edit") { action, index in
//            print("edit button tapped ", index)
//        }
//
//        edit.backgroundColor = UIColor.green
//
//        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
//            print("delete button tapped ")
//
//			let rootRef = Database.database().reference()
//
//            let row = self.appointmentData[index.row] as Appointment
//			rootRef.child("bookings").child(row.serviceProviderID).child(row.date).child(row.time).removeValue()
//
//            rootRef.child("appointment").child(String(row.userID!)).child(String(row.appointmentID!)).removeValue()
//            self.appointmentData.remove(at: index.row)
//
//            tableView.deleteRows(at: [index], with: .fade)
//
//        }
//        delete.backgroundColor = UIColor.red
//
////      return [edit, delete]
//        return [edit, delete]
//    }

