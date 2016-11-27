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
	@IBOutlet weak var userNameLabel: UILabel!
	
	@IBOutlet weak var locationImage: UIImageView!
	@IBOutlet weak var locationLabel: UILabel!
	
	@IBOutlet weak var numberOfStarsLabel: UILabel!
	@IBOutlet weak var numberOfReposLabel: UILabel!
	@IBOutlet weak var numberOfFollowingLabel: UILabel!
	@IBOutlet weak var numberOfFollowersLabel: UILabel!
	
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
