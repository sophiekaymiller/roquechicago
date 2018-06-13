#  Developer Notes 
## 	Sophie Miller
### Roque Salon Scheduling Application - 2018


### Swifty Store Kit 
	resource: https://github.com/bizz84/SwiftyStoreKit

**Test in sandbox mode using link below**
`itms-services://?action=purchaseIntent&bundleId=com.example.app&productIdentifier=product_name	`

**Downloading content hosted with Apple**

>Quoting Apple Docs:

*When you create a product in iTunes Connect, you can associate one or more pieces of downloadable content with it. At runtime, when a product is purchased by a user, your app uses SKDownload objects to download the content from the App Store.
Your app never directly creates a SKDownload object. Instead, after a payment is processed, your app reads the transaction object’s downloads property to retrieve an array of SKDownload objects associated with the transaction.
To download the content, you queue a download object on the payment queue and wait for the content to be downloaded. After a download completes, read the download object’s contentURL property to get a URL to the downloaded content. Your app must process the downloaded file before completing the transaction. For example, it might copy the file into a directory whose contents are persistent. When all downloads are complete, you finish the transaction. After the transaction is finished, the download objects cannot be queued to the payment queue and any URLs to the downloaded content are invalid.*


**added handler to app delegate for updating downloads** (6.11.18)


## Salon Settings View Controller
### Using Eureka to assist with Form Building 


## June 12 2018

- Created Calendar Animations with Scroll to Current Date
- Calendar Header View 


### To do
- Implement Compass to Route Application: _https://github.com/hyperoslo/Compass_


**ANYWHERE** in application the following function can send user to logout 

@IBOutlet func logoutButtonTouched() {
Navigator.navigate(urn: "logout")
}

- Model for TableControl implemented 


# To Do:
## Implement App Navigator to handle in app transitioning 





