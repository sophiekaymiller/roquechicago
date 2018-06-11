//
//  StoreViewController.swift
//
//
//  Created by Sophie Miller on 6/11/18.
//  Copyright © 2018 Sophie Miller. All rights reserved.
//

import UIKit
import SwiftyStoreKit

class StoreViewController: UIViewController {

    override func viewDidLoad() {
		super.viewDidLoad()
		
		SwiftyStoreKit.retrieveProductsInfo(["com.SophieMiller.RoqueSalon.FirstItem"]) { result in
			if let product = result.retrievedProducts.first {
				let priceString = product.localizedPrice!
				print("Product: \(product.localizedDescription), price: \(priceString)")
			}
			else if let invalidProductId = result.invalidProductIDs.first {
				print("Invalid product identifier: \(invalidProductId)")
			}
			else {
	
				print("Error: \(result.error ?? "error with StoreKit" as! Error)")
				}
		}
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	//Atomic: to be used when the content is delivered immediately.
	func purchaseProductWithId() {
		
		SwiftyStoreKit.purchaseProduct("com.SophieMiller.RoqueSalon.FirstItem", quantity: 1, atomically: true) { result in
			switch result {
			case .success(let purchase):
				print("Purchase Success: \(purchase.productId)")
			case .error(let error):
				switch error.code {
				case .unknown: print("Unknown error. Please contact support")
				case .clientInvalid: print("Not allowed to make the payment")
				case .paymentCancelled: break
				case .paymentInvalid: print("The purchase identifier was invalid")
				case .paymentNotAllowed: print("The device is not allowed to make the payment")
				case .storeProductNotAvailable: print("The product is not available in this location")
				case .cloudServicePermissionDenied: print("Access to cloud service information is not allowed")
				case .cloudServiceNetworkConnectionFailed: print("Could not connect to the network")
				case .cloudServiceRevoked: print("User has revoked permission to use this cloud service")
				}
			}
		}
	}
	
	//Non-Atomic: to be used when the content is delivered by the server.
	func purchaseProductFromServer() {
		SwiftyStoreKit.purchaseProduct("com.SophieMiller.RoqueSalon.FirstItem", quantity: 1, atomically: false) { result in
			switch result {
			case .success(let product):
				// fetch content from your server, then:
				if product.needsFinishTransaction {
					SwiftyStoreKit.finishTransaction(product.transaction)
				}
				print("Purchase Success: \(product.productId)")
			case .error(let error):
				switch error.code {
				case .unknown: print("Unknown error. Please contact support")
				case .clientInvalid: print("Not allowed to make the payment")
				case .paymentCancelled: break
				case .paymentInvalid: print("The purchase identifier was invalid")
				case .paymentNotAllowed: print("The device is not allowed to make the payment")
				case .storeProductNotAvailable: print("The product is not available in the current storefront")
				case .cloudServicePermissionDenied: print("Access to cloud service information is not allowed")
				case .cloudServiceNetworkConnectionFailed: print("Could not connect to the network")
				case .cloudServiceRevoked: print("User has revoked permission to use this cloud service")
				}
			}
		}
	}
	
	func getProductInfo(){
		SwiftyStoreKit.retrieveProductsInfo(["com.SophieMiller.RoqueSalon.FirstItem"]) { result in
			if let product = result.retrievedProducts.first {
				SwiftyStoreKit.purchaseProduct(product, quantity: 1, atomically: true) { result in
					// handle result (same as above)
				}
			}
		}
	}
	
    
}
   
