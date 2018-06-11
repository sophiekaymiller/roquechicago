//
//  AppointmentDataSource.swift
//  Confirmed
//
//  Created by Sophie Miller on 6/8/18.
//  Copyright © 2018 Sophie Miller. All rights reserved.
//

import Foundation
import FirebaseUI

class AppointmentDataSource: FUITableViewDataSource {
	
	// Override to support conditional editing of the table view.
	override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		
		return true
	}
	
	// Override to support editing the table view.
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		
		if editingStyle == .delete {
			snapshot(at: indexPath.row).ref.removeValue()
		}
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if self.count != 0 {
			tableView.separatorStyle = .singleLine
			tableView.backgroundView = nil
		}
		return Int(self.count)
	}
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		let noDataLabel = UILabel(frame: CGRect(origin: .zero, size: tableView.bounds.size))
		noDataLabel.text = "No appointments yet - why not add one?"
		noDataLabel.textColor = UIColor.black
		noDataLabel.textAlignment = .center
		tableView.backgroundView = noDataLabel
		tableView.separatorStyle = .none
		return 1
	}
	
}
