//
//  TabBarControllerViewController.swift
//  Confirmed
//
//  Created by Sophie Miller on 11/15/17.
//  Copyright © 2017 Confirmed. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

		title = "TabBarController"
		
		self.tabBar.items?[0].title = "Bookings"
		self.tabBar.items?[1].title = "New Calendar"
		self.tabBar.items?[2].title = "Appointments"
		self.tabBar.items?[3].title = "Charts"
		self.tabBar.items?[4].title = "Test"
//		self.tabBar.items?[5].title = "Logout"
		
	}
}
