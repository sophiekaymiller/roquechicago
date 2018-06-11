//
//  ServiceProvidersListViewController.swift
//  Confirmed
//
//  Created by Sophie Miller on 11/22/17.

// Roque Place ID
//	let placeID = "ChIJHz5Xo7IsDogRJwUX_bsudls"

import UIKit
import Firebase
import FirebaseUI
import GooglePlaces

class ServiceProviderListCell: UITableViewCell {
    
    @IBOutlet var profilePicture: UIImageView!
    @IBOutlet var serviceProviderTitle: UILabel!
//    @IBOutlet weak var serviceProviderRating: FloatRatingView!
    @IBOutlet var distanceToLocation: UILabel!

    
}

class SalonListTableViewCell: UITableViewCell{
	
	@IBOutlet var placeImage: UIImage!
	@IBOutlet var placeImageView: UIImageView!
	@IBOutlet var placeTitle: UILabel!
	@IBOutlet var distance: UILabel!
}

class ServiceProvidersListViewController: UITableViewController {
	
	var placesClient: GMSPlacesClient!
	var place: GMSPlace!
	
	
//	//initializing collections
//	var selectedCollection: PlaceCollection?
//	//Holds list of collections
//	var items: [PlaceCollection] = []
//
	// Cell reuse id (enables reuse of cells when they scroll out of view).
	let cellReuseIdentifier = "cell"
	
	@IBOutlet weak var collectionTable: UITableView!
	
	@IBOutlet weak var placeName: UILabel!
	@IBOutlet weak var placeAddress: UILabel!
	
	var placesList: NSMutableArray = []
	var placeLikelihoodArray: GMSPlaceLikelihoodList! //array
	var placeLikelihood: GMSPlaceLikelihood! //double
	
	let identifier = "SalonList"
	let nib = UINib(nibName: "SalonListTableViewCell", bundle: nil)


    let cellIdentifier = "ServiceProviderListCell"
    var selectedFinalCategory: String = ""
    var segueIdentifier = "BusinessPageViewControllerSegue"
	var ref: DatabaseReference!
	
	//FirebaseUI
	var array: FUIArray!
	
	var dataSource: FUITableViewDataSource?
	

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Results"
		
		ref = Database.database().reference()
		
		//let array = FUIArray(query: firebaseRef)
		
		
		dataSource = FUITableViewDataSource(query: getQuery()) { (tableView, indexPath, snap) -> UITableViewCell in
			let cell = tableView.dequeueReusableCell(withIdentifier: "reuseID", for: indexPath) as! SalonListTableViewCell

			guard let salon = Place(snapshot: snap) else{ return cell }
			cell.placeImage = UIImage(named: "ic_account_circle")
			cell.placeTitle.text = salon.placeName
			
			return cell
		}
		
//		// Delegate method and data source for the table view.
//		collectionTable.delegate = self
//		collectionTable.dataSource = self
		
		self.navigationItem.rightBarButtonItem = self.editButtonItem

		placesClient = GMSPlacesClient.shared()
		getPlaceDetails()
        self.tableView.reloadData()
		
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.tableView.reloadData()
	}
	
	func getPlaceDetails() {
		//ROQUE Place ID. To be replaced once tested.
		
		let placeID = ""
		
		placesClient.lookUpPlaceID(placeID, callback: { (place, error)->
			Void in
			if error != nil {
				print("lookup place id query error")
				return
			}
			guard let place = place else {
				print("no place found")
				return
			}
			print("Place name \(place.name)")
			print("\(String(describing: place.formattedAddress))")
  
		})
	}
	
	func loadFirstPhotoForPlace(placeID: String, imageView: UIImageView) {

		let placeID = "ChIJHz5Xo7IsDogRJwUX_bsudls"

		placesClient.lookUpPhotos(forPlaceID: placeID) { (photos, error) -> Void in
			if let error = error {
				// TODO: handle the error.
				print("Error: \(error)")
			} else {
				if let firstPhoto = photos?.results.first {
					self.loadImageForMetadata(photoMetadata: firstPhoto, imageView: imageView)
				}
			}
		}
	}

	func loadImageForMetadata(photoMetadata: GMSPlacePhotoMetadata, imageView: UIImageView) {


		placesClient.loadPlacePhoto(photoMetadata, constrainedTo: imageView.bounds.size,
							scale: imageView.window!.screen.scale) { (photo, error) -> Void in
								if let error = error {
									// TODO: handle the error.
									print("Error: \(error)")
								} else {
									imageView.image = photo;
									print("\n\nphoto : \(String(describing: photo?.description))\n\n")
									//self.imageView.description = photoMetadata.attributions;
								}
		}
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSections(in tableView: UITableView) -> Int {

		return 1
    }
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		performSegue(withIdentifier: "detailView", sender: indexPath)
	}
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 150
	}

	func getUid() -> String {
		return (Auth.auth().currentUser?.uid)!
	}
	
	func getQuery() -> DatabaseQuery {
		return self.ref
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard let indexPath: IndexPath = sender as? IndexPath else { return }
		guard let detail: BusinessPageViewController = segue.destination as? BusinessPageViewController else {
			return
		}
		if let dataSource = dataSource {
			detail.serviceKey = dataSource.snapshot(at: indexPath.row).key
		}
	}
	
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		print("\n\n-----\n2.Number of rows", self.placesList.count , "\n\n")
		return self.placesList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ServiceProviderListCell

        let result = placesList[indexPath.row] as! Place
		
		self.loadFirstPhotoForPlace(placeID: result.placeId , imageView: cell.profilePicture)
		print("Name: \(String(describing: result.placeName))");
		cell.serviceProviderTitle.text = result.placeName
		cell.distanceToLocation.text = String(format:"%.2f", result.distance) + " mi"

        return cell
    }
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		getQuery().removeAllObservers()
	}
	
    func do_table_refresh()
    {
        DispatchQueue.main.async(execute: {
            self.tableView.reloadData()
            print("reloading")
            return
        })
    }

}
