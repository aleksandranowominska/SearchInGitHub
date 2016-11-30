//
//  UserDetailsViewController.swift
//  SearchInGitHub
//
//  Created by Aleksandra Kusiak on 27.11.2016.
//  Copyright © 2016 ola. All rights reserved.
//

import UIKit

class UserDetailsViewController: UIViewController {

	@IBOutlet weak var userAvatar: UIImageView!
	@IBOutlet weak var userDetailsContainer: UIView!
	
	@IBOutlet weak var userNameLabel: UILabel!
	
	@IBOutlet weak var locationImage: UIImageView!
	@IBOutlet weak var locationLabel: UILabel!
	
	@IBOutlet weak var numberOfStarsLabel: UILabel!
	@IBOutlet weak var numberOfReposLabel: UILabel!
	@IBOutlet weak var numberOfFollowingLabel: UILabel!
	@IBOutlet weak var numberOfFollowersLabel: UILabel!
	
	@IBOutlet weak var starsLabel: UILabel!
	@IBOutlet weak var reposLabel: UILabel!
	@IBOutlet weak var followingLabel: UILabel!
	@IBOutlet weak var followersLabel: UILabel!
	
	
	var singleUser: SingleUserData?
	var userLogin: String?
	
    override func viewDidLoad() {
        super.viewDidLoad()
		setupView()
		DataManager.instance.getSingleUser(userLogin: userLogin!, userDownloaded: {user in
			self.singleUser = user
			self.reloadLabels()
		}, error: {error in
			print("error with getting single user")
		})
		DataManager.instance.getStarsQuantityForUser(userLogin: userLogin!, quantityDownloaded: {quantity in
			self.numberOfStarsLabel.text = "\(quantity)" //github api doesn't return number of stars, it returns json with 30 starred results. Here I should add paging, but it can be a lot of pages. That will send too much requests to api, I'm afraid that with the limited api version (even with added token) it won't work good :(
		}, error: {error in
			print("error with getting quantity of stars")
		})
    }
	

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func setupView(){
		userDetailsContainer.backgroundColor = UIColor.forkMidnightBlue
		userAvatar.layer.cornerRadius = 10.0
		userAvatar.clipsToBounds = true
		userAvatar.layer.borderWidth = 1
		userAvatar.layer.borderColor = UIColor.cloudsGrey.cgColor
		locationImage.tintColor = UIColor.cloudsGrey
		userNameLabel.textColor = UIColor.cloudsGrey
		locationLabel.textColor = UIColor.cloudsGrey
		starsLabel.textColor = UIColor.forkMidnightBlue
		numberOfStarsLabel.textColor = UIColor.forkMidnightBlue
		reposLabel.textColor = UIColor.forkMidnightBlue
		numberOfReposLabel.textColor = UIColor.forkMidnightBlue
		followingLabel.textColor = UIColor.forkMidnightBlue
		numberOfFollowingLabel.textColor = UIColor.forkMidnightBlue
		followersLabel.textColor = UIColor.forkMidnightBlue
		numberOfFollowersLabel.textColor = UIColor.forkMidnightBlue
		
		userAvatar.image = #imageLiteral(resourceName: "placeholder")
		userNameLabel.text = ""
		locationLabel.text = ""
		numberOfStarsLabel.text = ""
		numberOfReposLabel.text = ""
		numberOfFollowingLabel.text = ""
		numberOfFollowersLabel.text = ""

	}
	
	func reloadLabels(){
		if let user = singleUser{
			userAvatar.sd_setImage(with: URL(string: user.avatarURL), placeholderImage: #imageLiteral(resourceName: "placeholder"))
			userNameLabel.text = userLogin
			locationLabel.text = user.location
			numberOfReposLabel.text = "\(user.repos)"
			numberOfFollowingLabel.text = "\(user.following)"
			numberOfFollowersLabel.text = "\(user.followers)"
		}
	}
	

}
