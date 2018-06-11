import UIKit
import Firebase
import FirebaseUI

class BookingConfirmationViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var timePicker: UIPickerView!
    
    var place: Place?
    
    // Time for bookings
	var timeArray: [String] = []
	let firstTime: Double = 5
	let lastTime: Double = 22
	var currentTime: Double = 5
	var increment: Double = 15
	

	
    var timeDataSource = ["5:00", "5:30", "6:00", "6:30", "7:00", "7:30", "8:00", "8:30", "9:00", "9:30", "10:00", "10:30", "11:00", "11:30", "12:00", "12:30", "13:00", "13:30", "14:00", "14:30", "15:00", "15:30", "16:00", "16:30", "17:00", "17:30", "18:00", "18:30", "19:00", "19:30", "20:00", "20:30", "21:00", "21:30", "22:00"]

    var selectedTime: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.timePicker.dataSource = self;
        self.timePicker.delegate = self;
    }

    
    // Picker Delegate Functions
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return timeDataSource.count;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return timeDataSource[row]
    }
    
    
    // Get selected Date
    func getSelectedDate() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        let strDate = dateFormatter.string(from: datePicker.date)
        print("\nSelected Date: ", strDate)
        return strDate
    }
    
    // Get selected time slot
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        selectedTime = timeDataSource[row]
        print("\nSelected Time: ", selectedTime)
    }
    
    

    
    // Confirm booking
    @IBAction func confirmBookingClicked() {
        
        let email = AppState.sharedInstance.email!
		let userID = Auth.auth().currentUser!.uid
        let date = getSelectedDate()
        let time = selectedTime
//        let strTime = date + " " + time
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
//        let d: Date = formatter.date(from: strTime)
//        let milliseconds = d.timeIntervalSince1970
		let placeID = place?.placeId
		let placeName = place?.placeName
        let lat = place?.location?.coordinate.latitude
        let lng = place?.location?.coordinate.longitude
		let specialty = AppState.sharedInstance.category
        
        let status = "Pending"
        
        let tmp: String = email + placeID! + date + time;
        let appointmentID: Int = tmp.hashValue
        
		let bookingVal: NSDictionary = ["serviceproviderId": placeID!, "status": status, "timeSlot": time]
        let dt: String = "" + date + "//" + time
        let bookingChild: String = "bookings//" + placeID! + "//" + dt
        
        FirebaseHelper.save(child: bookingChild, value: bookingVal)
        
		let appointmentVal: NSDictionary = ["appointmentId": appointmentID, "userId": userID, "serviceProviderId": placeID!, "serviceProviderName": placeName, "lat": lat!, "lng": lng!, "date": date, "time": time, "speciality": specialty ?? ""]

		
        let appointmentChild: String = "appointment//" + String(userID) + "//" + String(appointmentID)
        
        FirebaseHelper.save(child: appointmentChild, value: appointmentVal)
        
        self.displayAlert(message: "Appointment Request Sent")
    }
    
    func bookingDone() {
        
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = mainStoryBoard.instantiateViewController(withIdentifier: "TabBarController")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = viewController
        let tabBarController: UITabBarController = (appDelegate.window?.rootViewController as? UITabBarController)!
        tabBarController.selectedIndex = 1
    }
    
    func displayAlert(message: String) {
        
        let alertController = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in
            // whatever else you need to do here
            self.bookingDone()
        }))
        
        present(alertController, animated: true, completion: nil)
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
