//
//  SalonSettingsTableViewController.swift
//  Confirmed
//
//  Created by Sophie Miller on 6/10/18.
//  Copyright © 2018 Sophie Miller. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps
import MapKit
import FirebaseUI
import Firebase

class SalonTableViewCell: UITableViewCell {
	
	static func boundingRectForText(_ text: String, maxWidth: CGFloat) -> CGRect {
		let rect = text.boundingRect(with: CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude),
									 options: [.usesLineFragmentOrigin],
									 context: nil)
		return rect
	}

	func populateCellWithSalon(_ salon: Place, user: User?, maxWidth: CGFloat) {
		self.textLabel?.text = salon.placeName
		
	}
	
}

class SalonSettingsTableViewController: UITableViewController {

	
	@IBOutlet fileprivate var textView: UITextView!
	@IBOutlet fileprivate var textField: UITextField!

	fileprivate var authStateListenerHandle: AuthStateDidChangeListenerHandle?
	fileprivate static let reuseIdentifier = "SalonTableViewCell"
	fileprivate var user: User?
	fileprivate let auth = Auth.auth()
	
	@IBOutlet fileprivate var sendButton: UIButton!

	
	var query: DatabaseQuery?
	var dataSource: FUITableViewDataSource!
	var salonRef: DatabaseReference = Database.database().reference().child("Salons")
		


	override func viewDidAppear(_ animated: Bool) {
		super .viewDidAppear(animated)
		
		self.query = self.salonRef.queryLimited(toLast: 50)
		
		self.dataSource = self.tableView.bind(to: query!) { tableView, indexPath, snap in
			// Dequeue cell
			let cell = tableView.dequeueReusableCell(withIdentifier: SalonSettingsTableViewController.reuseIdentifier, for: indexPath) as! SalonTableViewCell
			
			let salon = Place(snapshot: snap)!
			
			cell.populateCellWithSalon(salon, user: self.user, maxWidth: self.view.frame.size.width)
	
			/* populate cell */
			return cell
		}
		
			self.query!.observe(.childAdded, with: { [unowned self] _ in
			self.scrollToBottom(animated: true)
		})
		
		self.auth.signInAnonymously { (user, error) in
			if let error = error {
				// An error here means the user couldn't sign in. Correctly
				// handling it depends on the context as well as your app's
				// capabilities, but this is usually a good place to
				// present "retry" and "forgot your password?" screens.
				fatalError("Sign in failed: \(error.localizedDescription)")
			}
		}
		
		//handle keyboard movements
		NotificationCenter.default.addObserver(self,
											   selector: #selector(keyboardWillShow),
											   name: NSNotification.Name.UIKeyboardWillShow,
											   object: nil)
		NotificationCenter.default.addObserver(self,
											   selector: #selector(keyboardWillHide),
											   name: NSNotification.Name.UIKeyboardWillHide,
											   object: nil)
		

}
		
	override func viewWillDisappear(_ animated: Bool) {
			super.viewWillDisappear(animated)
			if let handle = self.authStateListenerHandle {
				self.auth.removeStateDidChangeListener(handle)
			}
			NotificationCenter.default.removeObserver(self)
		}
	

	@objc fileprivate func didTapSubmit(_ sender: AnyObject) {
		guard let user = self.auth.currentUser else { return }
		let uid = user.uid
		
		let name = "User " + uid[uid.startIndex..<uid.index(uid.startIndex, offsetBy: 6)]
		
		let _text = self.textField.text as String?
		guard let text = _text else { return }
		if (text.isEmpty) { return }
		
		let salon = Place(placeId: "", address: "", placeName: "", rating: 0.0, location: CLLocation.init() , status: "", distance: 1.0, website: "", timings: "", phoneNumber: "")
		
		self.salonRef.childByAutoId().setValue(salon) { (error, dbref) in
			if let error = error {
				// An error here most likely means the user doesn't have permission
				// to chat (not signed in?) or the user has no internet connection.
				fatalError("Failed to write message: \(error.localizedDescription)")
			}
		}
		
		self.textView.text = ""
	}

	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

	@objc fileprivate func keyboardWillShow(_ notification: Notification) {
		let userInfo = (notification as NSNotification).userInfo!
		let endFrameValue = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue
		let endHeight = endFrameValue.cgRectValue.size.height
		
		let curve = UIViewAnimationCurve(rawValue: userInfo[UIKeyboardAnimationCurveUserInfoKey] as! Int)!
		let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! Double
		
		UIView.setAnimationCurve(curve)
		UIView.animate(withDuration: duration, animations: {
			self.view.layoutIfNeeded()
		})
	}
	
	@objc fileprivate func keyboardWillHide(_ notification: Notification) {
		
		let userInfo = (notification as NSNotification).userInfo!
		let curve = UIViewAnimationCurve(rawValue: userInfo[UIKeyboardAnimationCurveUserInfoKey] as! Int)!
		let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! Double
		
		UIView.setAnimationCurve(curve)
		UIView.animate(withDuration: duration, animations: {
			self.view.layoutIfNeeded()
		})
	}
	
	fileprivate func scrollToBottom(animated: Bool) {
		let count = Int(self.dataSource.count)
		guard count > 0 else { return }
		let indexPath = IndexPath(item: count - 1, section: 0)
		self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: animated)
	}
	
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

}
