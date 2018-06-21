//
//  GoogleCalViewController.swift
//  Confirmed
//
//  Created by Sophie Miller on 6/20/18.
//  Copyright © 2018 Sophie Miller. All rights reserved.
//

import GoogleAPIClientForREST
import GoogleSignIn
import CVCalendar
import UIKit

class GoogleCalViewController: UIViewController {
	
	@IBOutlet weak var menuView: CVCalendarMenuView!
	@IBOutlet weak var calendarView: CVCalendarView!
	
	// If modifying these scopes, delete your previously saved credentials by
	// resetting the iOS simulator or uninstall the app.
	private let scopes = [kGTLRAuthScopeCalendar]
	
	private let service = GTLRCalendarService()
	let signInButton = GIDSignInButton()
	@IBOutlet var output:UITextView! = UITextView()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = "New Calendar"

		menuView.commitMenuViewUpdate()
		calendarView.commitCalendarViewUpdate()
		
		// Add a UITextView to display output.
		output.frame = view.bounds
		output.isEditable = false
		output.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
		output.autoresizingMask = [.flexibleHeight, .flexibleWidth]
		output.isHidden = true
		view.addSubview(output);
	}
	
//	func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
//			  withError error: Error!) {
//		if let error = error {
//			showAlert(title: "Authentication Error", message: error.localizedDescription)
////			self.service.authorizer = nil
//		} else {
//			self.signInButton.isHidden = true
//			self.output.isHidden = false
////			self.service.authorizer = user.authentication.fetcherAuthorizer()
//			fetchEvents()
//		}
//	}
	
	// Construct a query and get a list of upcoming events from the user calendar
	func fetchEvents() {
		let query = GTLRCalendarQuery_EventsList.query(withCalendarId: "primary")
		query.maxResults = 10
		query.timeMin = GTLRDateTime(date: Date())
		query.singleEvents = true
		query.orderBy = kGTLRCalendarOrderByStartTime
		service.executeQuery(
			query,
			delegate: self,
			didFinish: #selector(displayResultWithTicket(ticket:finishedWithObject:error:)))
	}
	
	// Display the start dates and event summaries in the UITextView
	@objc func displayResultWithTicket(
		ticket: GTLRServiceTicket,
		finishedWithObject response : GTLRCalendar_Events,
		error : NSError?) {
		
		if let error = error {
			showAlert(title: "Error", message: error.localizedDescription)
			return
		}
		
		var outputText = ""
		if let events = response.items, !events.isEmpty {
			for event in events {
				let start = event.start!.dateTime ?? event.start!.date!
				let startString = DateFormatter.localizedString(
					from: start.date,
					dateStyle: .short,
					timeStyle: .short)
				outputText += "\(startString) - \(event.summary!)\n"
			}
		} else {
			outputText = "No upcoming events found."
		}
		output.text = outputText
	}
	
	
	// Helper for showing an alert
	func showAlert(title : String, message: String) {
		let alert = UIAlertController(
			title: title,
			message: message,
			preferredStyle: UIAlertControllerStyle.alert
		)
		let ok = UIAlertAction(
			title: "OK",
			style: UIAlertActionStyle.default,
			handler: nil
		)
		alert.addAction(ok)
		present(alert, animated: true, completion: nil)
	}
}

extension GoogleCalViewController: CVCalendarViewDelegate {
	func presentationMode() -> CalendarMode {
		return .monthView
	}
	
	@IBAction func toWeekView(sender: AnyObject) {
		calendarView.changeMode(.weekView)
	}
	
	/// Switch to MonthView mode.
	@IBAction func toMonthView(sender: AnyObject) {
		calendarView.changeMode(.monthView)
	}
	
	func firstWeekday() -> Weekday {
		
		return .sunday
	}
	
	
	
}
