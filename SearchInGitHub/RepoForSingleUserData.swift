//
//  RepoForSingleUserData.swift
//  SearchInGitHub
//
//  Created by Aleksandra Kusiak on 17.12.2016.
//  Copyright © 2016 ola. All rights reserved.
//

import Foundation
import SwiftyJSON

class RepoForSingleUserData{
	
	let id: Int
	let repoTitle: String
	let repoName: String
	let repoDescription: String
	var repoLanguage: String
	let repoStars: Int
	let repoForks: Int
	let repoUpdate: Date
	
	let userName: String
	
	init(_ json: JSON){
		id = json["id"].intValue
		repoTitle = json["full_name"].stringValue
		repoName = json["name"].stringValue
		repoDescription = json["description"].stringValue
		repoLanguage = json["language"].stringValue
		if repoLanguage == "" {
			repoLanguage = "Unknown"
		}
		repoStars = json["stargazers_count"].intValue
		repoForks = json["forks_count"].intValue
		let dateString = json["updated_at"].stringValue
		// convrting string to date
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
		repoUpdate = dateFormatter.date(from: dateString)!

		userName = json["owner"]["login"].stringValue
		
		
	}
	
	
}
