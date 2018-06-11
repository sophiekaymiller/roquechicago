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
        self.tabBar.items?[0].image = UIImage(named: "home-icon")?.withRenderingMode(.alwaysTemplate)
        self.tabBar.items?[0].title = "Home"
		
        self.tabBar.items?[1].image = UIImage(named: "appointment-icon")?.withRenderingMode(.alwaysTemplate)
		self.tabBar.items?[1].title = "Appointments"
		
		self.tabBar.items?[2].image = UIImage(named: "call-alert-icon")?.withRenderingMode(.alwaysTemplate)
		self.tabBar.items?[2].title = "Calendar"
		
		self.tabBar.items?[3].image = UIImage(named: "price_level")?.withRenderingMode(.alwaysTemplate)
		self.tabBar.items?[3].title = "Charts"
		
		self.tabBar.items?[4].image = UIImage(named: "more-icon-1")?.withRenderingMode(.alwaysTemplate)
		self.tabBar.items?[4].title = "More"
		
		
		}

}
