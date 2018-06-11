//
//  GeneralFunctionHelper.swift
//  Confirmed
//
//  Created by Sophie Miller on 6/10/18.
//  Copyright © 2018 Sophie Miller. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseUI

class GeneralFunctionHelper {

	
func displayAlert(message: String) {
	
	let alertController = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.alert)
	alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
	
//	present(alertController, animated: true, completion: nil)
	
	}
}
