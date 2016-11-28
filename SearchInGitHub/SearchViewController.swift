//
//  SearchViewController.swift
//  SearchInGitHub
//
//  Created by Aleksandra Kusiak on 26.11.2016.
//  Copyright © 2016 ola. All rights reserved.
//

import UIKit
import SDWebImage

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating {

	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var octoView: UIView!
	
	@IBOutlet weak var octoInfoLabel: UILabel!
	@IBOutlet weak var octoImage: UIImageView!
	
	@IBOutlet weak var searchInGitHub: UISearchBar!
	var resultSearchController = UISearchController()
	var userArray: [AnyObject] = []
	var repoArray: [AnyObject] = []
	var resultArray: [AnyObject] = []
	
	@IBOutlet weak var progressCircle: UIActivityIndicatorView!
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
		//displaying octoView
		self.octoView.isHidden = false
		self.octoView.isUserInteractionEnabled = false
		
		//rows settings
		self.tableView.rowHeight = UITableViewAutomaticDimension
		self.tableView.estimatedRowHeight = 44.0
		
		//creating search Bar
		self.resultSearchController = UISearchController(searchResultsController: nil)
		self.resultSearchController.searchResultsUpdater = self
		self.resultSearchController.dimsBackgroundDuringPresentation = false
		self.resultSearchController.searchBar.sizeToFit()
		self.tableView.tableHeaderView = self.resultSearchController.searchBar
		
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return resultArray.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let result = resultArray[indexPath.row]
		
		if let userResult = result as? UserData{
			let cell = tableView.dequeueReusableCell(withIdentifier: "userCell") as! UserTableViewCell
			cell.userNameLabel.text = userResult.userName
			cell.userAvatar.sd_setImage(with: URL(string: userResult.avatarURL), placeholderImage: #imageLiteral(resourceName: "placeholder"))
			cell.userAvatar.layer.cornerRadius = 10.0
			cell.userAvatar.clipsToBounds = true
			return cell
		}
		
		if let repoResult = result as? RepositoryData{
			let cell = tableView.dequeueReusableCell(withIdentifier: "repoCell") as! RepoTableViewCell
			cell.titleLabel.text = repoResult.repoTitle
			cell.descriptionLabel.text = repoResult.repoDescription
			cell.languageLabel.text = repoResult.repoLanguage
			cell.starsLabel.text = "\(repoResult.repoStars)"
			cell.forksLabel.text = "\(repoResult.repoForks)"
			cell.repoAvatar.sd_setImage(with: URL(string: repoResult.avatarURL), placeholderImage: #imageLiteral(resourceName: "placeholder"))
			cell.repoAvatar.layer.cornerRadius = 10.0
			cell.repoAvatar.clipsToBounds = true
			cell.starIcon.tintColor = UIColor.starYellow
			cell.languageIcon.tintColor = UIColor.languageTurquoise
			cell.forkIcon.tintColor = UIColor.forkMidnightBlue
			
			let dateFormatter = DateFormatter()
			dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
			cell.updatedLabel.text = dateFormatter.string(from: repoResult.repoUpdate)
			return cell
		}
		//this should never happen
		fatalError("wrong object type")
	}
	
	//function which is launched when user is searching sth
	func updateSearchResults(for searchController: UISearchController) {
		if searchController.isActive == false { // to remember last typed query
			return
		}
		let searchText = searchController.searchBar.text!
		print("updateSearchResults wpisany tekst to\(searchText)")
		progressCircle.hidesWhenStopped = true
		progressCircle.tag = 2
		progressCircle.startAnimating()

		//search users
		DataManager.instance.getUsers(query: searchText, userNamesDownloaded: {users in
			print("found \(users.count) users")
			self.userArray = users
			self.progressCircle.stopAnimating()
			self.refreshTableView()
		}, userError: {error in
			print("user error")
			self.userArray = []
			self.progressCircle.stopAnimating()
			self.refreshTableView()
		})
		//search repos
		DataManager.instance.getRepos(query: searchText, userReposDownloaded: {repos in
			print("found \(repos.count) repos")
			self.repoArray = repos
			self.progressCircle.stopAnimating()
			self.refreshTableView()
		}, repoError: {error in
			print("repo error")
			self.repoArray = []
			self.progressCircle.stopAnimating()
			self.refreshTableView()
		})
		
	}
	
	func resultSorter(left: AnyObject, right: AnyObject) -> Bool{
		var leftId = 0
		if let leftUser = left as? UserData {
			leftId = leftUser.id
		} else if let leftRepo = left as? RepositoryData {
			leftId = leftRepo.id
		}
		
		var rightId = 0
		if let rightUser = right as? UserData {
			rightId = rightUser.id
		} else if let rightRepo = right as? RepositoryData {
			rightId = rightRepo.id
		}
		
		return leftId < rightId
	}
	
	func refreshTableView(){
		resultArray = userArray + repoArray
		print("updateSearchResults refreshTV \(resultArray.count)")
		if (resultSearchController.searchBar.text?.characters.count)! <= 3 {
			if resultSearchController.isActive == false {
				self.octoInfoLabel.text = "Search to display"
				self.octoImage.image = #imageLiteral(resourceName: "Octocat")
				self.octoView.isHidden = false
			}
			else {
			self.octoView.isHidden = true
			}
		}
		else if resultSearchController.searchBar.text! != "" {
			if resultArray.count == 0{
				self.octoInfoLabel.text = "Sorry, nothing here. \n" + "Try again"
				self.octoImage.image = #imageLiteral(resourceName: "OctocatSad_")
				self.octoView.isHidden = false
			}
			else if resultArray.count != 0 {
				self.octoView.isHidden = true
			}
		}
		else if resultSearchController.isActive == false {
			self.octoInfoLabel.text = "Search to display"
			self.octoImage.image = #imageLiteral(resourceName: "Octocat")
			self.octoView.isHidden = false
		}


		resultArray.sort(by: resultSorter)
		//print("result array has \(resultArray.count) elements")
		self.tableView.reloadData()
		//for result in resultArray {
		//print("id result \((result as? UserData)?.id ?? -1 ) \((result as? RepositoryData)?.id ?? -1 )" )
		//}
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		//serchBarController hide and preserve text
		let searchText = resultSearchController.searchBar.text
		resultSearchController.searchResultsUpdater = nil
		resultSearchController.isActive = false
		resultSearchController.searchBar.text = searchText
		resultSearchController.searchResultsUpdater = self

		
		if segue.identifier == "goToUserDetails"{
			let destination = segue.destination as! UserDetailsViewController
			let selectedUser = resultArray[tableView.indexPathForSelectedRow!.row] as! UserData
			destination.userLogin =  selectedUser.userName
		}
		else if segue.identifier == "goToRepoDetails"{
		}
	}
	
}
