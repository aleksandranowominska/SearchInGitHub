//
//  SearchViewController.swift
//  SearchInGitHub
//
//  Created by Aleksandra Kusiak on 26.11.2016.
//  Copyright © 2016 ola. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

	@IBOutlet weak var tableView: UITableView!
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
		DataManager.instance.getUsers(query: "tom", userNamesDownloaded: {users in
			print("found \(users.count) users")
		}, userError: {error in
		print("user error")
		
		})
		DataManager.instance.getRepos(query: "tom", userReposDownloaded: {repos in
			print("found \(repos.count) repos")
		}, repoError: {error in
			print("repo error")
			})

        // Do any additional setup after loading the view.
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
	
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
