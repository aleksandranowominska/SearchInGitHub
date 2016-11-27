//
//  SingleUser.swift
//  SearchInGitHub
//
//  Created by Aleksandra Kusiak on 27.11.2016.
//  Copyright © 2016 ola. All rights reserved.
//

import Foundation
import SwiftyJSON

class SingleUserData{

	let avatarURL: String
	let location: String
	//let stars: Int
	let repos: Int
	let following: Int
	let followers: Int
	
	init(_ json: JSON){
		
		avatarURL = json["avatar_url"].stringValue
		location = json["location"].stringValue
		//stars
		repos = json["public_repos"].intValue
		following = json["following"].intValue
		followers = json["followers"].intValue
	}
	
}
