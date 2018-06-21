//
//  CategoriesViewController.swift
//  Confirmed
//
//  Created by Sophie Miller on 11/20/17.
//  Copyright © 2017 Confirmed. All rights reserved.
//

import UIKit
import Firebase
import GooglePlaces
import GooglePlacePicker

class CategoryTableViewCell: UITableViewCell {
	
    @IBOutlet var categoryImage: UIImageView!
    @IBOutlet var categoryTitle: UILabel!
	@IBOutlet weak var onboardingButton: UIButton!


}

class CategoriesViewController: UITableViewController, CLLocationManagerDelegate {
    
    //DataSource
    var categories: [String] = []
    var images: [String] = []
    let cellIdentifier = "CategoryCell"
    
    let segueSubCategory = "SubCategoryViewControllerSegue"
    let segueSPList = "DirectServiceProvidersListSegue"
    
    //Search bar
    var fetcher: GMSAutocompleteFetcher?
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    var locationManager: CLLocationManager!
	
	var onboardingViewController = OnboardingViewController()

	
	//map implementation
	var placePickerDelegate: GMSPlacePickerViewControllerDelegate!
	
	@IBOutlet weak var mapButton: UIBarButtonItem!
	
	@IBAction func mapButtonClicked(_ sender: Any) {
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		title = "Bookings"
		
        categories = ["Haircut", "Blow Dry", "Hair Color", "EyeLashes", "Other"]
        images = ["scissors", "hairdryer", "dye", "hairdresser-chair", "more-icon"]

		
        // Navigation bar button
        navigationItem.leftBarButtonItem =
            UIBarButtonItem(image: UIImage(named: "location"), landscapeImagePhone: nil, style: UIBarButtonItemStyle.plain, target: self, action: #selector(CategoriesViewController.navButtonClicked))
		
		
        //        textField = UITextField(frame: CGRect(x: 5.0, y: 0, width: self.view.bounds.size.width - 5.0, height: 44.0))
        //        textField?.autoresizingMask = .flexibleWidth
        //        textField?.addTarget(self, action: Selector(("textFieldDidChange:")), for: .editingChanged)
        
        let filter = GMSAutocompleteFilter()
        filter.type = .address  //suitable filter type
        
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.autocompleteFilter = filter
        resultsViewController?.delegate = self
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.requestLocation()
        locationManager.requestAlwaysAuthorization()
        
        
        // Put the search bar in the navigation bar.
		
        searchController?.searchBar.sizeToFit()
        navigationItem.titleView = searchController?.searchBar
        
        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
		
        definesPresentationContext = true
        
        // Prevent the navigation bar from being hidden when searching.
		
        searchController?.hidesNavigationBarDuringPresentation = false
    }
	
	
	@IBAction func onboardingPressed(_ sender: UIButton) {
		
		performSegue(withIdentifier: "showOnboarding", sender: self)
		
	}
	
	@IBAction func showBooking(_ sender: Any) {
		performSegue(withIdentifier: "showBooking", sender: self)
	}
	
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks, error)-> Void in
            if (error != nil) {
                print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
                return
            }
            
            if (placemarks?.count)! > 0 {
                let pm = (placemarks?[0])! as CLPlacemark
//                print(pm.name)
                self.searchController?.searchBar.text = pm.name
                AppState.sharedInstance.location = pm.location
            } else {
                print("Problem with the data received from geocoder")
            }
        })
		
    }
    
    @objc func navButtonClicked() {
        print("Button Clicked")
		
        CLGeocoder().reverseGeocodeLocation(locationManager.location!, completionHandler: {(placemarks, error)-> Void in
            if (error != nil) {
                print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
                return
            }
            
            if (placemarks?.count)! > 0 {
                let pm = (placemarks?[0])! as CLPlacemark
//                print(pm.name)
                self.searchController?.searchBar.text = pm.name
                AppState.sharedInstance.location = pm.location
            } else {
                print("Problem with the data received from geocoder")
            }
        })
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CategoryTableViewCell
        // Configure the cell...
        let category = categories[indexPath.row]
        cell.categoryImage.image = UIImage(named: images[indexPath.row])
        cell.categoryTitle.text = "  " + category

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    
    
    // MARK: - Table view Delegate Methods
	
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = categories[indexPath.row]
        print(category)
        if(indexPath.row > 1){
            performSegue(withIdentifier: segueSPList, sender: nil)
            tableView.deselectRow(at: indexPath, animated: true)
        } else {
            //performSegue(withIdentifier: segueSubCategory, sender: nil)
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == segueSubCategory {
            if let indexPath = tableView.indexPathForSelectedRow {
                let category = categories[indexPath.row]
                let destinationViewController = segue.destination as! SubCategoryViewController

                destinationViewController.selectedCategory = category
            }
        }
        if segue.identifier == segueSPList {
            if let indexPath = tableView.indexPathForSelectedRow {

				//categories = ["Haircut", "Blow Dry", "Hair Color", "EyeLashes", "Other"]

                var category = categories[indexPath.row]
				
                if(category == "Haircut"){
                    category = "hair_care"
                    print("hair_care--")
				}
				if(category == "Blow Dry"){
					category = "blow_dry"
					print("Blow Dry--")
					}
				if(category == "Hair Color"){
					category = "hair_color"
					print("Color--")
					}
				if(category == "EyeLashes"){
					category = "eyelashes"
					print("EyeLashes--")
					}
				if(category == "Other"){
					category = "other"
					print("Other--")
					}
			let destinationViewController = segue.destination as! ServiceProvidersListViewController
			destinationViewController.selectedFinalCategory = category
			}
        }
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

// Search bar
// Handle the user's selection.
extension CategoriesViewController: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        // Do something with the selected place.
        searchController?.searchBar.text = place.name
        AppState.sharedInstance.location = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        print("Place name: \(place.name)")
        print("Place ID : \(place.types)")
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
