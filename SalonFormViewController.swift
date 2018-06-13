//
//  SalonFormViewController.swift
//  Confirmed
//
//  Created by Sophie Miller on 6/11/18.
//  Copyright © 2018 Sophie Miller. All rights reserved.
//

import UIKit
import Eureka

class SalonFormViewController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

		super.viewDidLoad()
		form +++ Section("Basic Information")
			<<< TextRow(){ row in
				row.title = "Text Row"
				row.placeholder = "Enter text here"
			}
			<<< PhoneRow(){
				$0.title = "Phone Row"
				$0.placeholder = "And numbers here"
			}
			+++ Section("Details")
			<<< DateRow(){
				$0.title = "Date Row"
				$0.value = Date(timeIntervalSinceReferenceDate: 0)
		}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
