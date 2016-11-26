//
//  UserData.swift
//  SearchInGitHub
//
//  Created by Aleksandra Kusiak on 26.11.2016.
//  Copyright © 2016 ola. All rights reserved.
//

import Foundation
import SwiftyJSON

class UserData{
	
	let userID: Int
	let userName: String
	let avatarURL: String
	
	init(_ json: JSON){
		userID = json["id"].intValue
		userName = json["login"].stringValue
		avatarURL = json["avatar_url"].stringValue
	}
	

}
