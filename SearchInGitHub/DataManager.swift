//
//  DataManager.swift
//  SearchInGitHub
//
//  Created by Aleksandra Kusiak on 26.11.2016.
//  Copyright © 2016 ola. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class DataManager{
	
	static let instance = DataManager()
	
	let apiURL = "https://api.github.com/"
	let searchUsersApi = "search/users?q="
	let searchReposApi = "search/repositories?q="
	let searchSingleUser = "users/"
	let starsForUser = "/starred"
	
	weak var previousUserQueryRequest: DataRequest?
	weak var previousRepoQueryRequest: DataRequest?
	
	private init(){
	}
	
	//get quantity stars for single user from Api
	func getStarsQuantityForUser(userLogin: String, quantityDownloaded: @escaping (_ quantity: Int) -> Void, userError: @escaping (_ error: String) -> Void){
		
		let starsURL = apiURL + searchSingleUser + userLogin + starsForUser
		
		let request = Alamofire.request(starsURL)
		request.responseJSON(completionHandler: {response in //request for single user data
			debugPrint(response)
			if let resultValue = response.result.value{
				let json = JSON(resultValue)
				quantityDownloaded(json.arrayValue.count)
			}
			else {
				userError(response.result.error.debugDescription)
			}

		})
	}
	
	//get single user from Api
	func getSingleUser(userLogin: String, userDownloaded: @escaping (_ userInfo: SingleUserData) -> Void, userError: @escaping (_ error: String) -> Void){
		
		let singleUserURL = apiURL + searchSingleUser + userLogin
		
		let request = Alamofire.request(singleUserURL)
		request.responseJSON(completionHandler: {response in //request for single user data
			debugPrint(response)
			if let resultValue = response.result.value{
				let json = JSON(resultValue)
				userDownloaded(SingleUserData(json))
			}
			else {
				userError(response.result.error.debugDescription)
			}

		})
	}
	
	//get users from Api
	func getUsers(query: String, userNamesDownloaded: @escaping (_ userInfo: [UserData]) -> Void, userError: @escaping (_ error: String) -> Void){
		let queryEncoded = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) //replace space to %20 in URL
		let userURL = apiURL + searchUsersApi + queryEncoded!
		
		if let requestToCancel = previousUserQueryRequest { //cancel previous user request to server
			requestToCancel.cancel()
		}
		let request = Alamofire.request(userURL)
		previousUserQueryRequest = request
		
		request.responseJSON(completionHandler: {response in //request for user data
			debugPrint(response)
			if let resultValue = response.result.value{
				let json = JSON(resultValue)
				let items = json["items"].arrayValue
				var foundUsers: [UserData] = []
				for item in items{
					foundUsers.append(UserData(item))
				}
				userNamesDownloaded(foundUsers)
			}
			else {
				userError(response.result.error.debugDescription)
			}
			
		})
		
	}
	
	//get repos from Api
	func getRepos(query: String, userReposDownloaded: @escaping (_ repoInfo: [RepositoryData]) -> Void, repoError: @escaping (_ error: String) -> Void){
		let queryEncoded = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) //replace space to %20 in URL
		let repoURL = apiURL + searchReposApi + queryEncoded!
		
		if let requestToCancel = previousRepoQueryRequest { //cancel previous repo request to server
			requestToCancel.cancel()
		}
		let request = Alamofire.request(repoURL)
		previousRepoQueryRequest = request
		
		request.responseJSON(completionHandler: {response in //request for repo data
			debugPrint(response)
			if let resultValue = response.result.value{
				let json = JSON(resultValue)
				let items = json["items"].arrayValue
				var foundRepos: [RepositoryData] = []
				for item in items{
					foundRepos.append(RepositoryData(item))
					
				}
				userReposDownloaded(foundRepos)
			}
			else {
				repoError(response.result.error.debugDescription)
			}
			
		})
		
	}

	
}
