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
	enum SearchStatus{
		case beforeSearch
		case searching
		case results
		case error (String)
	}
	
	var searchStatus: SearchStatus = .beforeSearch {
		didSet{
			updateViewsFor(status: searchStatus)
		}
	}

	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var octoView: UIView!
	
	@IBOutlet weak var octoInfoLabel: UILabel!
	@IBOutlet weak var octoImage: UIImageView!
	
	var resultSearchController = UISearchController()
	var userArray: [AnyObject]?
	var repoArray: [AnyObject]?
	var resultArray: [AnyObject] = []
	
	@IBOutlet weak var progressCircle: UIActivityIndicatorView!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		//hiding keyboard when not used
		self.tableView.keyboardDismissMode = .onDrag
		
		self.progressCircle.hidesWhenStopped = true
		
		searchStatus = .beforeSearch
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
	
	// MARK: TableView functions
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
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
	// MARK: Other functions
	
	func updateViewsFor(status: SearchStatus){
		switch status {
		case .beforeSearch:
			DataManager.instance.cancelAllRequests()
			resultArray.removeAll()
			tableView.reloadData()
			octoInfoLabel.text = "Search to display"
			octoImage.image = #imageLiteral(resourceName: "Octocat")
			octoView.isHidden = false
			progressCircle.stopAnimating()
		case .searching:
			octoView.isHidden = true
			progressCircle.startAnimating()
		case .results:
			if resultArray.count == 0{
				octoInfoLabel.text = "Sorry, nothing here. \n" + "Try again"
				octoImage.image = #imageLiteral(resourceName: "OctocatSad_")
				octoView.isHidden = false
			}
			else if resultArray.count != 0 {
				octoView.isHidden = true
			}
			progressCircle.stopAnimating()
		case let .error(errorMessage):
			resultArray.removeAll()
			tableView.reloadData()
			octoImage.image = #imageLiteral(resourceName: "OctocatSad_")
			octoInfoLabel.text = "Error! \n" + errorMessage
			octoView.isHidden = false
			progressCircle.stopAnimating()
		}
	}
	
	//function which is launched when user is searching sth
	func updateSearchResults(for searchController: UISearchController) {
		let searchText = searchController.searchBar.text!
		if searchText == "" {
			searchStatus = .beforeSearch
			return
		}
		searchStatus = .searching
		userArray = nil
		repoArray = nil
		
		//search users
		DataManager.instance.getUsers(query: searchText, usersDownloaded: {users in
			self.userArray = users
			self.refreshTableView()
		}, error: {error in
			self.searchStatus = .error(error)
		})
		//search repos
		DataManager.instance.getRepos(query: searchText, reposDownloaded: {repos in
			self.repoArray = repos
			self.refreshTableView()
		}, error: {error in
			self.searchStatus = .error(error)
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
		guard let userArrayUnwrapped = userArray
			else {return}
		guard let repoArrayUnwrapped = repoArray
			else {return}
		resultArray = userArrayUnwrapped + repoArrayUnwrapped
		searchStatus = .results
		resultArray.sort(by: resultSorter)
		tableView.reloadData()
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
			destination.userLogin = selectedUser.userName
		}
		else if segue.identifier == "goToRepoDetails"{
			let destination = segue.destination as! RepoDetailsViewController
			let selectedRepo = resultArray[tableView.indexPathForSelectedRow!.row] as! RepositoryData
			destination.userLogin = selectedRepo.userName
			destination.repoName = selectedRepo.repoName
		}
	}
	
}
