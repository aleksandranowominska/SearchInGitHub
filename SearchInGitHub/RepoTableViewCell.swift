//
//  RepoTableViewCell.swift
//  SearchInGitHub
//
//  Created by Aleksandra Kusiak on 26.11.2016.
//  Copyright © 2016 ola. All rights reserved.
//

import UIKit

class RepoTableViewCell: UITableViewCell {
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var descriptionLabel: UILabel!
	@IBOutlet weak var languageLabel: UILabel!
	@IBOutlet weak var starsLabel: UILabel!
	@IBOutlet weak var forksLabel: UILabel!
	@IBOutlet weak var updatedLabel: UILabel!
	@IBOutlet weak var repoAvatar: UIImageView!
	
	@IBOutlet weak var languageIcon: UIImageView!
	@IBOutlet weak var starIcon: UIImageView!
	@IBOutlet weak var forkIcon: UIImageView!
}
