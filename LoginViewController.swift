//
//  LoginViewController.swift
//  Confirmed
//
//  Created by Sophie Miller on 11/13/17.
//

import UIKit
import Firebase
import FirebaseUI
import FirebaseDatabase
import FirebaseAuth
import FBSDKLoginKit
import GoogleSignIn


class LoginViewController: UIViewController, FBSDKLoginButtonDelegate, GIDSignInUIDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
	
	
	enum UserType: String {
		case admin = "admin"
		case employee = "employee"
		case client = "client"
	}
	
	
	// ----- Login Function -----
	@IBOutlet weak var userEmail: UITextField!
	@IBOutlet weak var userPassword: UITextField!
	//@IBOutlet weak var pickerUIVIEW: UIView!


    //Container view
    // add all subviews to this view
    @IBOutlet weak var containerView: UIView!
	@IBOutlet weak var userPickerView: UIPickerView!
	@IBOutlet weak var googleSigninButton: GIDSignInButton!
	
	
	@IBOutlet weak var loginButton: UIButton!
	
	
	//Firebase Database
	var rootRef: DatabaseReference!
	var db: Database!
	var user: User!
	
	//FUI Options
	var bool:Bool = false
	
    // Facebook login button
	var fbLoginButton: FBSDKButton!
	
	var x: CGFloat = 0, y: CGFloat = 0
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Header BG")!)
		//Enable persistent data
		Database.database().isPersistenceEnabled = true
        let defaults = UserDefaults()

        if(defaults.value(forKey: "is_logged_in") as! String? == "true"){
            //defaults.register(defaults: defaultVal)
            bool = true
        } else{
            let defaultVal = ["is_logged_in" : "false"]
            defaults.register(defaults: defaultVal)
        }
		
		userPickerView.delegate = self
		userPickerView.dataSource = self
	
        // Add facebook login button
//		let titleText = NSAttributedString(string: "login")
//
//        fbLoginButton.setAttributedTitle(titleText, for: UIControlState.normal)
//        x = (self.view.frame.width / 2) - 55
//        y = googleSigninButton.frame.minY - 60
//        fbLoginButton.frame = CGRect(x: x, y: y, width: 110, height: 40)
//        self.fbLoginButton.readPermissions = ["public_profile", "email"]
//
//        self.fbLoginButton.delegate = self
//        containerView.addSubview(fbLoginButton)
		
        // if user signed in using email and password
		
		if let user = Auth.auth().currentUser {
			MeasurementHelper.sendLoginEvent()
			AppState.sharedInstance.signedIn = true
            AppState.sharedInstance.email = user.email
            self.performSegue(withIdentifier: "loginSuccessful", sender: self)
        }
        
        // if user already signed in using fb
        if (FBSDKAccessToken.current() != nil) {
            // User is logged in, do work such as go to next view controller.
            // use 'accessToken' here.
            print("\n\n-----\nUser already logged in using fb\n-----\n\n");

		}
		
        // set GIDSignIn object
		//Make a symbolic breakpoint at UIViewAlertForUnsatisfiableConstraints to catch this in the debugger.
		
        GIDSignIn.sharedInstance().uiDelegate = self
//		GIDSignIn.sharedInstance().signInSilently()

    }
	

	// ----- Picker implementation -----
	
	let userTypes: [[UserType]] = [[UserType.admin, UserType.client, UserType.employee]]

	
	var typeSelected: String = ""
	
	@IBOutlet weak var switchUser: UIButton!

	
	@IBAction func switchUserType(_ sender: Any, forEvent event: UIEvent) {
	
		
	
	}

	func numberOfComponents(in userPickerView: UIPickerView) -> Int {
		return 1
	}
	// The number of columns
	
	func pickerView(_ userPickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return userTypes[0].count
	}
	// The number of rows
	
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return userTypes[component][row].rawValue
	}
	// This connects the user array to the actual picker
	
	func pickerView(_ userPickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		typeSelected = userTypes[0][row].rawValue
		// now, every time someone changes the Picker View's value, typeSelected will be whatever they chose.
	}
    
    @IBAction func didTapSignIn(_ sender: AnyObject) {
        // Sign In with credentials.
        guard let email = userEmail.text, let password = userPassword.text else { return }
        print("\n\n-----\n1. ", email, " ", password, "\n-----\n\n")
		Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            print("\n\n-----\n2. ", email, " ", password, "\n-----\n\n")
            if let error = error {
                // alert here
                print(error.localizedDescription)
				self.displayAlert(message: "Incorrect Email or Password!")
                return
            }
            else {
                AppState.sharedInstance.email = email
                self.performSegue(withIdentifier: "loginSuccessful", sender: self)
            }
			MeasurementHelper.sendLoginEvent()
			AppState.sharedInstance.signedIn = true
        }
    }
    
    
    // ----- Create Account -----
    @IBAction func createAccount() {
        
        performSegue(withIdentifier: "CreateAccountSegue", sender: nil)
        
    }
    
    // Facebook login
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        else {
            print("\n\n-----\nFB login success\n------\n\n ")
            let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
			Auth.auth().signInAndRetrieveData(with: credential) { (user, error) in
			}
				
                // ...
                print("\n\n-----\nFB Firebase auth success\n------\n\n ")
                AppState.sharedInstance.signedIn = true;
                let mainStoryBoard = UIStoryboard(name: "MainConfirmed", bundle: nil)
                let viewController = mainStoryBoard.instantiateViewController(withIdentifier: "TabBarController")
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = viewController
                
                AppState.sharedInstance.email = user?.email
            }
	}
    
    // Facebook logout
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("\n\n-----\nFB User Logged Out\n------\n\n ")
    }
    
    
    // Google sign out
    @IBAction func didTapSignOut(sender: AnyObject) {
        GIDSignIn.sharedInstance().signOut()
    }

    func signedIn(_ user: User) {
//		self.rootRef.child("users").child(user.uid).setValue(["userType": typeSelected])
        MeasurementHelper.sendLoginEvent()
        AppState.sharedInstance.signedIn = true
		//retrieveData()

    }
    

    func displayAlert(message: String) {
        
        let alertController = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.alert)
         alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func retrieveData() {
        rootRef.child("users").observe(.value, with: { snapshot in
            print(snapshot.value!)
        })
    }
}
