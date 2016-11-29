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

	let headers = ["Authorization": "token 67f4878b5549fcf49f56762addd8ad4c7d1847d1"] // that's private token (user: ciurkam) used only to this project to have better access to GitHub API
	
	let apiURL = "https://api.github.com/"
	let searchUsersApi = "search/users?q="
	let searchReposApi = "search/repositories?q="
	let searchSingleUser = "users/"
	let starsForUser = "/starred"
	
	weak var previousUserQueryRequest: DataRequest?
	weak var previousRepoQueryRequest: DataRequest?
	
	private init(){
	}
	
	
	func cancelAllRequests(){
		previousRepoQueryRequest?.cancel()
		previousUserQueryRequest?.cancel()
	}

	//get quantity stars for single user from Api
	func getStarsQuantityForUser(userLogin: String, quantityDownloaded: @escaping (_ quantity: Int) -> Void, userError: @escaping (_ error: String) -> Void){
		
		let starsURL = apiURL + searchSingleUser + userLogin + starsForUser
		
		let request = Alamofire.request(starsURL, headers: headers)
		request.responseJSON(completionHandler: {response in //request for single user data
			debugPrint(response)
			if let resultValue = response.result.value{
				let json = JSON(resultValue)
				if let errorMessage = json["message"].string{
					userError(errorMessage)
				}
				else{
					quantityDownloaded(json.arrayValue.count)
				}
			}
			else {
				userError(response.result.error.debugDescription)
			}

		})
	}
	
	//get single user from Api
	func getSingleUser(userLogin: String, userDownloaded: @escaping (_ userInfo: SingleUserData) -> Void, userError: @escaping (_ error: String) -> Void){
		
		let singleUserURL = apiURL + searchSingleUser + userLogin
		
		let request = Alamofire.request(singleUserURL, headers: headers)
		request.responseJSON(completionHandler: {response in //request for single user data
			debugPrint(response)
			if let resultValue = response.result.value{
				let json = JSON(resultValue)
				if let errorMessage = json["message"].string{
					userError(errorMessage)
				}
				else{
					userDownloaded(SingleUserData(json))
				}
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
		
		previousUserQueryRequest?.cancel()
	
		let request = Alamofire.request(userURL, headers: headers)
		previousUserQueryRequest = request
		
		request.responseJSON(completionHandler: {response in //request for user data
			debugPrint(response)
			if let resultValue = response.result.value{
				let json = JSON(resultValue)
				if let errorMessage = json["message"].string{
					userError(errorMessage)
				}
				else{
					let items = json["items"].arrayValue
					var foundUsers: [UserData] = []
					for item in items{
						foundUsers.append(UserData(item))
					}
					userNamesDownloaded(foundUsers)
				}
				
			}
			else {
				if let cancelError = response.result.error as? NSError {
					if cancelError.code == -999 {return} // ignore canceled requests
				}
				userError(response.result.error.debugDescription)
			}
			
		})
		
	}
	
	//get repos from Api
	func getRepos(query: String, userReposDownloaded: @escaping (_ repoInfo: [RepositoryData]) -> Void, repoError: @escaping (_ error: String) -> Void){
		let queryEncoded = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) //replace space to %20 in URL
		let repoURL = apiURL + searchReposApi + queryEncoded!
		
		previousRepoQueryRequest?.cancel()
		
		let request = Alamofire.request(repoURL, headers: headers)
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
				if let cancelError = response.result.error as? NSError {
					if cancelError.code == -999 {return} // ignore canceled requests
				}
				repoError(response.result.error.debugDescription)
			}
			
		})
		
	}

	
}
