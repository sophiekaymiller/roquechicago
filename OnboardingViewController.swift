//
//  OnboardingViewController.swift
//  Confirmed
//
//  Created by Sophie Miller on 6/15/18.
//  Copyright © 2018 Sophie Miller. All rights reserved.
//

import UIKit
import paper_onboarding

protocol OnboardingControllerDelegate: class {
}

class OnboardingViewController: UIViewController {



	@IBOutlet weak var onboardingView: PaperOnboarding!

	override func viewDidLoad() {
		super.viewDidLoad()

		onboardingView.delegate = self
		onboardingView.dataSource = self

	}
}



extension OnboardingViewController: PaperOnboardingDelegate {


	func onboardingDidTransitonToIndex(_: Int) {

		return
	}



	func onboardingConfigurationItem(_ item: OnboardingContentViewItem, index: Int) {

		item.titleLabel?.backgroundColor = .red
		item.descriptionLabel?.backgroundColor = .black

		return
	}
}

// MARK: PaperOnboardingDataSource
extension OnboardingViewController: PaperOnboardingDataSource {
	func onboardingItemsCount() -> Int {
		return 3
	}


	func onboardingItem(at index: Int) -> OnboardingItemInfo {
		let items =
			[OnboardingItemInfo(
				informationImage: UIImage(named: "hairdryer")!, title: "Request appointment in one of our salons",
				description: "",
				pageIcon: UIImage(named: "hairbrush")!,
				color: UIColor.white,
				titleColor: UIColor.black,
				descriptionColor: UIColor.black,
				titleFont: UIFont.boldSystemFont(ofSize: 40),
				descriptionFont: UIFont.systemFont(ofSize: 18)),
			OnboardingItemInfo(informationImage: UIImage(named: "mirror")!,
				title: "Access your private member account",
				description: "Keep track of your services, favorite locations, and products",
				pageIcon: UIImage(named: "button-background")!,
				color: .purple,
				titleColor: UIColor.black,
				descriptionColor: UIColor.black,
				titleFont: UIFont.boldSystemFont(ofSize: 40),
				descriptionFont: UIFont.systemFont(ofSize: 18)),
			OnboardingItemInfo(informationImage: UIImage(named: "hair_softener")!,
				title: "Easily order your favorite products",
				description: "",
				pageIcon: UIImage(named: "button-background")!,
				color: UIColor.red,
				titleColor: UIColor.black,
				descriptionColor: UIColor.black,
				titleFont: UIFont.boldSystemFont(ofSize: 40),
				descriptionFont: UIFont.systemFont(ofSize: 18)),]
				
				return items[index]
	}
}

//MARK: Constants
	extension OnboardingViewController {

		private static let titleFont = UIFont(name: "Nunito-Bold", size: 36.0) ?? UIFont.boldSystemFont(ofSize: 36.0)
		private static let descriptionFont = UIFont(name: "OpenSans-Regular", size: 14.0) ?? UIFont.systemFont(ofSize: 14.0)
	}

