//
//  SearchViewController.swift
//  SearchInGitHub
//
//  Created by Aleksandra Kusiak on 26.11.2016.
//  Copyright © 2016 ola. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating {

	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var searchInGitHub: UISearchBar!
	var resultSearchController = UISearchController()
	var userArray: [AnyObject] = []
	var repoArray: [AnyObject] = []
	var resultArray: [AnyObject] = []
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.resultSearchController = UISearchController(searchResultsController: nil)
		self.resultSearchController.searchResultsUpdater = self
		self.resultSearchController.dimsBackgroundDuringPresentation = false
		self.resultSearchController.searchBar.sizeToFit()
		self.tableView.tableHeaderView = self.resultSearchController.searchBar
		self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		return UITableViewCell()
	}
	
	//function which is launched when user is searching sth
	func updateSearchResults(for searchController: UISearchController) {
		let searchText = searchController.searchBar.text!
		let progressCircle = UIActivityIndicatorView(activityIndicatorStyle: .gray)
		progressCircle.hidesWhenStopped = true
		progressCircle.tag = 2
		searchController.searchBar.addSubview(progressCircle)
		progressCircle.startAnimating()

		//search users
		DataManager.instance.getUsers(query: searchText, userNamesDownloaded: {users in
			print("found \(users.count) users")
			self.userArray = users
			progressCircle.stopAnimating()
			self.refreshTableView()
		}, userError: {error in
			print("user error")
			self.userArray = []
			progressCircle.stopAnimating()
			self.refreshTableView()
		})
		//search repos
		DataManager.instance.getRepos(query: searchText, userReposDownloaded: {repos in
			print("found \(repos.count) repos")
			self.repoArray = repos
			progressCircle.stopAnimating()
			self.refreshTableView()
		}, repoError: {error in
			print("repo error")
			self.repoArray = []
			progressCircle.stopAnimating()
			self.refreshTableView()
		})
		
	}
	
	func refreshTableView(){
		resultArray = userArray + repoArray
		print("result array is \(resultArray.count)")
		self.tableView.reloadData()
	}

}
