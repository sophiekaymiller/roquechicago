//
//  TempLogoutViewController.swift
//  Confirmed
//
//  Created by Sophie Miller on 11/21/17.
//  Copyright © 2017 Confirmed. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
import Compass

class TempLogoutViewController: UIViewController {
	
	@IBAction func goToTestPlaces(_ sender: UIButton) {
		performSegue(withIdentifier: "goToTest", sender: self)
	}
	
	@IBAction func goToAccountSettings(_ sender: Any) {
		performSegue(withIdentifier: "goToSettings", sender: self)
	}
	override func viewDidLoad() {
        super.viewDidLoad()

		title = "Logout"		
    }

    @IBAction func signout() {
        
		let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            AppState.sharedInstance.signedIn = false
            dismiss(animated: true, completion: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: \(signOutError.localizedDescription)")
        }
        
        print("\n\n-----\nLogout Clicked\n-----\n\n")
        let mainStoryBoard = UIStoryboard(name: "MainConfirmed", bundle: nil)
		
        let loginViewController: LoginViewController = mainStoryBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = loginViewController

    }
    
}
