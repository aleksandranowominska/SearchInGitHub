//
//  UserDetailsViewController.swift
//  SearchInGitHub
//
//  Created by Aleksandra Kusiak on 27.11.2016.
//  Copyright © 2016 ola. All rights reserved.
//

import UIKit

class UserDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

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
	
	@IBOutlet weak var tableView: UITableView!
	
	var singleUser: SingleUserData?
	var userLogin: String?
	var arrayWithUserRepos: [RepoForSingleUserData] = []
	
    override func viewDidLoad() {
        super.viewDidLoad()
		setupView()
		//rows settings
		self.tableView.rowHeight = UITableViewAutomaticDimension
		self.tableView.estimatedRowHeight = 44.0
		
		//downloading data from Api
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
		
		DataManager.instance.getReposForUser(userLogin: userLogin!, repoDownloaded: {repo in
			self.arrayWithUserRepos = repo
			self.tableView.reloadData()
		}, error: {error in
			print("error with getting repos for single user")
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
	
	// MARK: TableVieW functions
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return arrayWithUserRepos.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let result = arrayWithUserRepos[indexPath.row]
		
			let cell = tableView.dequeueReusableCell(withIdentifier: "repoforSingleUserCell") as! RepoForSingleUserTableViewCell
			cell.titleLabel.text = result.repoTitle
			cell.descriptionLabel.text = result.repoDescription
			cell.languageLabel.text = result.repoLanguage
			cell.starsLabel.text = "\(result.repoStars)"
			cell.forksLabel.text = "\(result.repoForks)"
			cell.starIcon.tintColor = UIColor.starYellow
			cell.languageIcon.tintColor = UIColor.languageTurquoise
			cell.forkIcon.tintColor = UIColor.forkMidnightBlue
			
			let dateFormatter = DateFormatter()
			dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
			cell.updatedLabel.text = dateFormatter.string(from: result.repoUpdate)
			return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

		if segue.identifier == "goToRepoDetailsFromUser"{
			let destination = segue.destination as! RepoDetailsViewController
			let selectedRepo = arrayWithUserRepos[tableView.indexPathForSelectedRow!.row]
			destination.userLogin = selectedRepo.userName
			destination.repoName = selectedRepo.repoName
		}
	}

}
