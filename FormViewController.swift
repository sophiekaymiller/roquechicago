//
//  FormViewController.swift
//  Confirmed
//
//  Created by Sophie Miller on 6/21/18.
//  Copyright © 2018 Sophie Miller. All rights reserved.
//

import UIKit
import Eureka
import Pastel
import Firebase


class MyFormNavController: UINavigationController, RowControllerType {
	var onDismissCallback : ((UIViewController) -> ())?
}

class MyFormViewController: FormViewController {



	@IBOutlet weak var SaveButton: UIButton!
	var value: String?

	fileprivate var db: Database!
	fileprivate var ref: DatabaseReference!
	fileprivate var helper: FirebaseHelper!


	let row = SwitchRow("SwitchRow") { row in // initializer
		row.title = "The title"
	}.onChange { row in
		row.title = (row.value ?? false) ? "The title expands when on" : "The title"
		row.updateCell()
	}.cellSetup { cell, row in
		cell.backgroundColor = .lightGray
	}.cellUpdate { cell, row in
		cell.textLabel?.font = .italicSystemFont(ofSize: 18.0)
	}

	var navigationOptionsBackup: RowNavigationOptions?


	override func viewDidLoad() {
		super.viewDidLoad()

		initializeForm()

		// Enables the navigation accessory and stops navigation when a disabled row is encountered
		navigationOptions = RowNavigationOptions.Enabled.union(.StopDisabledRow)
		
		navigationItem.leftBarButtonItem?.target = self
		navigationItem.leftBarButtonItem?.action = #selector(MyFormViewController.cancelTapped(_:))

		// Enables smooth scrolling on navigation to off-screen rows
		animateScroll = true

		// Leaves 20pt of space between the keyboard and the highlighted row after scrolling to an off screen row
		rowKeyboardSpacing = 20

	}

	private func initializeForm() {
		form +++ Section("BasicInfoSection")
		<<< NameRow() { row in
			row.title = "First Name"
			row.placeholder = "Enter first name here"
		}
		<<< NameRow() { row in
			row.title = "Last Name"
			row.placeholder = "Enter last name here"
		}
		<<< PhoneRow() {
			$0.title = "Phone Row"
			$0.placeholder = "Enter Phone #"
		}
		<<< URLRow() { row in
			row.title = "Website URL"
			row.placeholder = "Enter Web Adress Here"
		}
			+++ Section("DateSection")
		<<< DateRow() {
			$0.title = "Birthday"
			$0.value = Date(timeIntervalSinceReferenceDate: 0)
		}

		form +++ Section()
		<<< SwitchRow("SalonRow") {
			$0.title = "Looking for Hair Salon"
		}
		<<< LabelRow() {

			$0.hidden = Condition.function(["SalonRow"], { form in
					return !((form.rowBy(tag: "SalonRow") as? SwitchRow)?.value ?? false)
				})
			$0.title = "On"
		}

		form +++ Section()
		<<< SwitchRow("LashRow") {
			$0.title = "Looking for Lash Extensions"
		}
		<<< LabelRow() {
			$0.hidden = Condition.function(["LashRow"], { form in
					return !((form.rowBy(tag: "LashRow") as? SwitchRow)?.value ?? false)
				})
			$0.title = "On"
		}
		form +++ SelectableSection<ListCheckRow<String>>("Where do you live", selectionType: .singleSelection(enableDeselection: true))

		let states = ["New York", "Chicago", "other"]
		for option in states {
			form.last! <<< ListCheckRow<String>(option) { listRow in
				listRow.title = option
				listRow.selectableValue = option
				listRow.value = nil
			}
		}

		form +++
			MultivaluedSection(multivaluedOptions: [.Reorder, .Insert, .Delete],
				header: "Employee Types",
				footer: "Insert a new employee") {
				$0.addButtonProvider = { section in
					return ButtonRow() {
						$0.title = "Add New Type"
					}
				}
				$0.multivaluedRowToInsertAt = { index in
					return NameRow() {
						$0.placeholder = "Type Name"
					}
				}
				$0 <<< NameRow() {
					$0.placeholder = "Type Name"
				}
		}
	}

	@objc func cancelTapped(_ barButtonItem: UIBarButtonItem) {
		(navigationController as? MyFormNavController)?.onDismissCallback?(self)
	}


	@IBAction func saveToFirebase(_ sender: Any) {
		FirebaseHelper.save(child: "profile", value: form.values() as NSDictionary)

	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	func setupForm() {

	}

	func getRowValue(row: TextRow) -> String {

		let row: TextRow! = form.rowBy(tag: "MyRowTag")
		let value = row.value ?? "no value"

		return value
	}

	func getAllValuesWithTag(form: Form) -> [String: Any?] {

		let valuesDictionary = form.values()

		return valuesDictionary
	}

}

