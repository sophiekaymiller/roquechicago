//
//  AppState.swift
//  Confirmed
//
//  Created by Sophie Miller on 11/15/17.
//  Copyright © 2017 Confirmed. All rights reserved.
//

import Foundation
import GooglePlaces

class AppState: NSObject {
    
    static let sharedInstance = AppState()
    
    var signedIn = false
    var location: CLLocation? = nil
    var email: String?
    var category: String?
    
}
