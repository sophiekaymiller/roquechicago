//
//  InputViewController.swift
//  Confirmed
//
//  Created by Sophie Miller on 6/10/18.
//  Copyright © 2018 Sophie Miller. All rights reserved.
//

import UIKit
import FirebaseUI
import Firebase

class InputViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

		return 1
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		self.dataSource = self.tableView.bind(to: query) { tableView, indexPath, snapshot in
			// Dequeue cell
			let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
			/* populate cell */
			return cell
		}
		
	}
	
	
	var tableDatasource: FUIIndexTableViewDataSource!
	var tableData: FUISortedArray
	var fireTableDataSource: FUITableViewDataSource
	@IBOutlet var salonSettingsTableView: UITableView!

	@IBOutlet weak var nameLabel: UILabel!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		nameLabel.text = "Salon Name"
		
		salonSettingsTableView.delegate = self as UITableViewDelegate
		salonSettingsTableView.dataSource = fireTableDataSource

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	

}


