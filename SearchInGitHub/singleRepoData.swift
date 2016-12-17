//
//  singleRepoData.swift
//  SearchInGitHub
//
//  Created by Aleksandra Kusiak on 17.12.2016.
//  Copyright © 2016 ola. All rights reserved.
//

import Foundation
import SwiftyJSON

class SingleRepoData{
	
	let avatarURL: String
	let fullName: String
	let userLogin: String
	let description: String
	let language: String
	let forks: Int
	let stars: Int
	let watchers: Int
	let issues: Int
	
	init(_ json: JSON){
		
		avatarURL = json["owner"]["avatar_url"].stringValue
		fullName = json["full_name"].stringValue
		userLogin = json["owner"]["login"].stringValue
		description = json["description"].stringValue
		language = json["language"].stringValue
		forks = json["forks_count"].intValue
		stars = json["stargazers_count"].intValue
		watchers = json["watchers_count"].intValue
		issues = json["open_issues_count"].intValue
	}
	
}
