//
//  UserView.swift
//  Aardvark
//
//  Created by Sophie Miller on 6/12/18.
//

import UIKit
import Compass
import Firebase

class UserView: UIView {

	let avatarImageView = UIImageView()
	let nameLabel = UILabel()
	let bioLabel = UILabel()
	let websiteLabel = UILabel()
	let mediaCountLabel = UILabel()
	let mediaTextLabel = UILabel()
	let followsCountButton = UIButton()
	let followsTextLabel = UILabel()
	let followedByCountButton = UIButton()
	let followedByTextLabel = UILabel()
	let salonNameTextLabel = UILabel()
	let messageButton = UIButton()

	private var userId: String?
	weak var delegate: UserViewDelegate?
	
	func configure(with user: User) {
		self.userId = user.id
		
		avatarImageView.kf.setImage(with: user.avatar)
		nameLabel.text = user.name
		bioLabel.text = user.bio
		websiteLabel.text = user.website
		mediaCountLabel.text = "\(user.counts?.media ?? 0)"
		followsCountButton.setTitle("\(user.counts?.follows ?? 0)", for: .normal)
		followedByCountButton.setTitle("\(user.counts?.followedBy ?? 0)", for: .normal)
	}

}
