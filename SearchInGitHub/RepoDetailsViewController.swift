//
//  RepoDetailsViewController.swift
//  SearchInGitHub
//
//  Created by Aleksandra Kusiak on 27.11.2016.
//  Copyright © 2016 ola. All rights reserved.
//

import UIKit

class RepoDetailsViewController: UIViewController {

	@IBOutlet weak var userAvatar: UIImageView!
	@IBOutlet weak var userDetailsContainer: UIView!
	
	@IBOutlet weak var fullNameLabel: UILabel!
	@IBOutlet weak var languageLabel: UILabel!
	@IBOutlet weak var descriptionLabel: UILabel!
	
	@IBOutlet weak var numberOfStarsLabel: UILabel!
	@IBOutlet weak var numberOfForksLabel: UILabel!
	@IBOutlet weak var numberOfIssuesLabel: UILabel!
	@IBOutlet weak var numberOfWatchersLabel: UILabel!
	
	@IBOutlet weak var starsLabel: UILabel!
	@IBOutlet weak var forksLabel: UILabel!
	@IBOutlet weak var issuesLabel: UILabel!
	@IBOutlet weak var watchersLabel: UILabel!
	
	var singleRepo: SingleRepoData?
	var userLogin: String?
	var repoName: String?
	
    override func viewDidLoad() {
		super.viewDidLoad()
		setupView()
		DataManager.instance.getSingleRepo(userLogin: userLogin!, repoName: repoName!, repoDownloaded: {repo in
			self.singleRepo = repo
			self.reloadLabels()
		}, error: {error in
			print("error with getting single repo")
		})
    }

	func setupView(){
		userDetailsContainer.backgroundColor = UIColor.forkMidnightBlue
		userAvatar.layer.cornerRadius = 10.0
		userAvatar.clipsToBounds = true
		userAvatar.layer.borderWidth = 1
		userAvatar.layer.borderColor = UIColor.cloudsGrey.cgColor
		fullNameLabel.textColor = UIColor.cloudsGrey
		languageLabel.textColor = UIColor.cloudsGrey
		descriptionLabel.textColor = UIColor.cloudsGrey
		starsLabel.textColor = UIColor.forkMidnightBlue
		numberOfStarsLabel.textColor = UIColor.forkMidnightBlue
		forksLabel.textColor = UIColor.forkMidnightBlue
		numberOfForksLabel.textColor = UIColor.forkMidnightBlue
		issuesLabel.textColor = UIColor.forkMidnightBlue
		numberOfIssuesLabel.textColor = UIColor.forkMidnightBlue
		watchersLabel.textColor = UIColor.forkMidnightBlue
		numberOfWatchersLabel.textColor = UIColor.forkMidnightBlue
		
		userAvatar.image = #imageLiteral(resourceName: "placeholder")
		fullNameLabel.text = ""
		languageLabel.text = ""
		descriptionLabel.text = ""
		numberOfStarsLabel.text = ""
		numberOfForksLabel.text = ""
		numberOfIssuesLabel.text = ""
		numberOfWatchersLabel.text = ""
		
	}
	
	func reloadLabels(){
		if let repo = singleRepo{
			userAvatar.sd_setImage(with: URL(string: repo.avatarURL), placeholderImage: #imageLiteral(resourceName: "placeholder"))
			fullNameLabel.text = repo.fullName
			languageLabel.text = "language: \(repo.language)"
			descriptionLabel.text = repo.description
			numberOfStarsLabel.text = "\(repo.stars)"
			numberOfForksLabel.text = "\(repo.forks)"
			numberOfIssuesLabel.text = "\(repo.issues)"
			numberOfWatchersLabel.text = "\(repo.watchers)"
		}
	}

}
