//
//  AppDelegate.swift
//  Confirmed
//
//  Created by Sophie Miller on 11/13/17.
//  Copyright © 2017 Confirmed. All rights reserved.
//

import UIKit
import CoreData
import FirebaseCore
import FirebaseAuth
import FirebaseDatabase
import FBSDKLoginKit
import GoogleSignIn
import GoogleMaps
import GooglePlaces
import GooglePlacePicker
import SwiftyStoreKit
import Compass


@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

	var window: UIWindow?

	var loginViewController: LoginViewController?
	var tabController: TabBarController?
	var onboardingViewController: OnboardingViewController?
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		
		FirebaseApp.configure()

		window?.tintColor = .purple
		
		UINavigationBar.appearance().barTintColor =
			UIColor(red: 254 / 255, green: 254 / 255, blue: 254 / 255, alpha: 1)

		showLogin()

//		if AppState.sharedInstance.signedIn == false {
		//
//		}
//		else {
//			showTabs()
//		}
		
		window?.makeKeyAndVisible()
		
		
		FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)

		GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
		GIDSignIn.sharedInstance().delegate = self

		// Google places API
		GMSPlacesClient.provideAPIKey("AIzaSyDdY_v1PYWY7ZcZh22NfWeUfBQFm8lIKOo")

		//Google Services API Key
		GMSServices.provideAPIKey("AIzaSyDdY_v1PYWY7ZcZh22NfWeUfBQFm8lIKOo")
		
//		GIDSignIn.sharedInstance().clientID = "AIzaSyDdY_v1PYWY7ZcZh22NfWeUfBQFm8lIKOo"

		Navigator.scheme = "compass"

		return true
	}


	func showLogin() {
		loginViewController = UIStoryboard(name: "MainConfirmed", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
		loginViewController?.delegate = self as? LoginControllerDelegate
		window?.rootViewController = loginViewController!

		tabController = nil
	}

	func showTabs() {
		tabController = UIStoryboard(name: "MainConfirmed", bundle: nil).instantiateViewController(withIdentifier: "TabBarController") as? TabBarController
		window?.rootViewController = tabController!
		loginViewController = nil
	}

	func loginControllerDidFinish(_ controller: LoginViewController) {
		showTabs()
	}

	func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
		let handled: Bool = FBSDKApplicationDelegate.sharedInstance().application(application, open: url as URL?, sourceApplication: sourceApplication, annotation: annotation)
		// Add any custom logic here
		return handled
	}

	// Google Sign in
	func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey: Any] = [:]) -> Bool {
		return GIDSignIn.sharedInstance().handle(url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
	}

	public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
		if let error = error {
			print(error.localizedDescription)
			return
	}

		print("Google Sign in success")
		let authentication = user.authentication
		let credential = GoogleAuthProvider.credential(withIDToken: (authentication?.idToken)!, accessToken: (authentication?.accessToken)!)

		Auth.auth().signInAndRetrieveData(with: credential, completion: { (result, error) in

			print("\n\nFirebase Google Authentication success\n\n")

			
			// Delete after testing
			let mainStoryBoard = UIStoryboard(name: "MainConfirmed", bundle: nil)
			let viewController = mainStoryBoard.instantiateViewController(withIdentifier: "TabBarController")
			let appDelegate = UIApplication.shared.delegate as! AppDelegate
			appDelegate.window?.rootViewController = viewController

			AppState.sharedInstance.email = user?.profile.email

		})

	}

	func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser?, withError error: Error!) {
		// ...
	}

	func applicationDidBecomeActive(_ application: UIApplication) {

		FBSDKAppEvents.activateApp()
	}

	func applicationWillTerminate(_ application: UIApplication) {

		self.saveContext()
	}

	// MARK: - Core Data stack

	lazy var persistentContainer: NSPersistentContainer = {

		var container = NSPersistentContainer(name: "Confirmed")
		container.loadPersistentStores(completionHandler: { (storeDescription, error) in
			if let error = error as NSError? {

				print("\(container.name)")

				fatalError("Unresolved error \(error), \(error.userInfo)")
			}
		})
		return container
	}()

	// MARK: - Core Data Saving support

	func saveContext () {
		let context = persistentContainer.viewContext
		if context.hasChanges {
			do {
				try context.save()
			} catch {
				// Replace this implementation with code to handle the error appropriately.
				// fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
				let nserror = error as NSError
				fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
			}
		}
	}

}

struct LogoutRoute: Routable {
	func navigate(to location: Location, from currentController: CurrentController) throws {
		if Auth.auth().currentUser == nil {
			(UIApplication.shared.delegate as! AppDelegate).showLogin()
		}
	}
}

extension AppDelegate {

	
	func showOnboarding() {
		if let window = window, let onboardingViewController = UIStoryboard(name: "Onboarding", bundle: nil).instantiateViewController(withIdentifier: "OnboardingViewController") as? OnboardingViewController {
			window.makeKeyAndVisible()
			window.rootViewController?.present(onboardingViewController, animated: false, completion: nil)
		} else {
			showLogin()
		}
	}
	
	func onboardingControllerDidFinish(_ controller: OnboardingViewController) {
		showLogin()
	}
	
	func hideOnboarding() {
		if let window = UIApplication.shared.keyWindow {
			window.rootViewController?.dismiss(animated: true, completion: nil)
		}
	}
}

