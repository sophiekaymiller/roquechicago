//
//  MeasurementHelper.swift
//  Confirmed
//
//  Created by Sophie Miller on 11/15/17.
//  Copyright © 2017 Confirmed. All rights reserved.
//

import Firebase

class MeasurementHelper: NSObject {
    
    static func sendLoginEvent() {
		Analytics.logEvent(AnalyticsEventLogin, parameters: nil)
    }
    
    static func sendLogoutEvent() {
		Analytics.logEvent("logout", parameters: nil)
    }
    
    static func sendMessageEvent() {
		Analytics.logEvent("message", parameters: nil)
    }

    
}
