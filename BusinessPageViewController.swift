import UIKit
import MapKit
import GooglePlaces
import Firebase
import FloatRatingView




class BusinessPageViewController: UIViewController {

    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var timings: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var ratingBar: FloatRatingView!
    @IBOutlet weak var speciality: UITextView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var addressFull: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var phoneNumber: UIButton!
    @IBOutlet weak var website: UIButton!
    
    @IBOutlet weak var mapView: MKMapView!
    
    var placesClient: GMSPlacesClient?
    var placesList: GMSPlaceLikelihoodList?
	var serviceKey = ""
	
	var db: Database!
	var ref: DatabaseReference!
	var placeRef: DatabaseReference!
    
    var segueIdentifier = "BookingConfirmationSegue"
    
    var place: Place!
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
		let db = Database.database()
		let ref = db.reference()
		let placeRef = ref.child("places")

        self.name.text = place.placeName
        self.addressFull.text = place.address
		self.ratingBar.rating = place.rating
        self.speciality.text = ""
		self.distance.text = String(format:"%.2f", (place?.distance)!) + " mi"
		
        //self.timings.text = place!.timings ?? "No Time Available"
        
//        if place!.status == "Closed"{
//            self.status.backgroundColor = UIColor.red
//        }
//        self.status.text = place!.status ?? ""
//        
       // self.get_data_from_url(url: "https://maps.googleapis.com/maps/api/place/details/json?placeid=\((place!.placeId)!)&key=AIzaSyDdY_v1PYWY7ZcZh22NfWeUfBQFm8lIKOo")
        
		self.loadFirstPhotoForPlace(placeID: (place.placeId), imageView: self.profileImage)
        
        placesClient = GMSPlacesClient.shared()
        
        placesClient!.lookUpPlaceID(place.placeId, callback: { (place: GMSPlace?, error: Error?) -> Void in
            if let error = error {
                print("lookup place id query error: \(error.localizedDescription)")
                return
            }
            
            if let place_ol = place {
				self.website.setTitle(place_ol.website!.absoluteString , for: .normal)
				self.place?.phoneNumber = place_ol.phoneNumber!
                
//                self.status.text = place?.openNowStatus == 0 ? "Closed" : "Open"
                
				print("\n\n\n\n\n\n----\(self.place!.website) \(self.place!.phoneNumber)----\n\n\n\n\n\n")
                
                self.loadFirstPhotoForPlace(placeID: (place!.placeID), imageView: self.profileImage)
            } else {
				print("No place details for \(self.place.placeId)")
            }
        })
//
//        WebServiceHelper.getData(url: "https://maps.googleapis.com/maps/api/place/details/json?placeid=\(placeID)&key=AIzaSyDdY_v1PYWY7ZcZh22NfWeUfBQFm8lIKOo", obj: timings)
//        
        
        // Do any additional setup after loading the view.
//        var url = ""
//        WebServiceHelper.getData(url: url, controller: self)
    }

    func loadFirstPhotoForPlace(placeID: String, imageView: UIImageView) {
        GMSPlacesClient.shared().lookUpPhotos(forPlaceID: placeID) { (photos, error) -> Void in
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
        GMSPlacesClient.shared()
            .loadPlacePhoto(photoMetadata, constrainedTo: imageView.bounds.size,
                            scale: imageView.window!.screen.scale) { (photo, error) -> Void in
                                if let error = error {
                                    // TODO: handle the error.
                                    print("Error: \(error)")
                                } else {
                                    imageView.image = photo;
									print("\n\nphoto : \(photo?.description ?? "")\n\n")
                                    //self.imageView.description = photoMetadata.attributions;
                                }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            
            let destinationViewController = segue.destination as! BookingConfirmationViewController
            destinationViewController.place = self.place

    }
    
    @IBAction func bookNowClicked() {
        performSegue(withIdentifier: segueIdentifier, sender: nil)
    }
    
    @IBAction func callButtonClicked() {
        let phNo = self.place.phoneNumber
        let phNoUrl = "tel://" + phNo.replacingOccurrences(of: "\\D", with: "", options: .regularExpression)
        print(phNoUrl)
        UIApplication.shared.open(URL(string: phNoUrl)!)
    }
    
    @IBAction func websiteClicked() {
        UIApplication.shared.open(URL(string: self.website.title(for: .normal)!)!)
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
