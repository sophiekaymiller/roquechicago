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

        // Do any additional setup after loading the view.
		self.tabBar.items?[0].title = "Bookings"
		self.tabBar.items?[1].title = "Calendar"
		self.tabBar.items?[2].title = "Appointments"
		self.tabBar.items?[3].title = "Charts"
		self.tabBar.items?[4].title = "More"
		self.tabBar.items?[5].title = "Test"
		}
}
