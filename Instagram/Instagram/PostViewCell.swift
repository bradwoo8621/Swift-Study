//
//  PostViewCell.swift
//  Instagram
//
//  Created by brad.wu on 2017/4/25.
//  Copyright © 2017年 bradwoo8621. All rights reserved.
//

import UIKit

class PostViewCell: UITableViewCell {
	@IBOutlet weak var avaImg: UIImageView!
	@IBOutlet weak var usernameBtn: UIButton!
	@IBOutlet weak var dateLbl: UILabel!

	@IBOutlet weak var picImg: UIImageView!
	@IBOutlet weak var likeBtn: UIButton!
	@IBOutlet weak var commentsBtn: UIButton!
	@IBOutlet weak var moreBtn: UIButton!
	@IBOutlet weak var likeLbl: UILabel!
	@IBOutlet weak var titleLbl: UILabel!
	@IBOutlet weak var puuidLbl: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		
		let width = UIScreen.main.bounds.width
		
		avaImg.translatesAutoresizingMaskIntoConstraints = false
		usernameBtn.translatesAutoresizingMaskIntoConstraints = false
		dateLbl.translatesAutoresizingMaskIntoConstraints = false
		picImg.translatesAutoresizingMaskIntoConstraints = false
		likeBtn.translatesAutoresizingMaskIntoConstraints = false
		commentsBtn.translatesAutoresizingMaskIntoConstraints = false
		moreBtn.translatesAutoresizingMaskIntoConstraints = false
		likeLbl.translatesAutoresizingMaskIntoConstraints = false
		titleLbl.translatesAutoresizingMaskIntoConstraints = false
		puuidLbl.translatesAutoresizingMaskIntoConstraints  = false
		
		let picWidth = width - 20
		
		self.contentView.addConstraints(NSLayoutConstraint.constraints(
			withVisualFormat: "V:|-10-[ava(30)]-10-[pic(\(picWidth))]-5-[like(30)]",
			options: [], metrics: nil,
			views: ["ava": avaImg, "pic": picImg, "like": likeBtn]))
		self.contentView.addConstraints(NSLayoutConstraint.constraints(
			withVisualFormat: "V:|-10-[username]",
			options: [], metrics: nil,
			views: ["username": usernameBtn]))
		self.contentView.addConstraints(NSLayoutConstraint.constraints(
			withVisualFormat: "V:[pic]-5-[comment(30)]",
			options: [], metrics: nil,
			views: ["pic": picImg, "comment": commentsBtn]))
		self.contentView.addConstraints(NSLayoutConstraint.constraints(
			withVisualFormat: "V:|-15-[date]",
			options: [], metrics: nil,
			views: ["date": dateLbl]))
		self.contentView.addConstraints(NSLayoutConstraint.constraints(
			withVisualFormat: "V:[like]-5-[title]-5-|",
			options: [], metrics: nil,
			views: ["like": likeBtn, "title": titleLbl]))
		self.contentView.addConstraints(NSLayoutConstraint.constraints(
			withVisualFormat: "V:[pic]-5-[more(30)]",
			options: [], metrics: nil,
			views: ["pic": picImg, "more": moreBtn]))
		self.contentView.addConstraints(NSLayoutConstraint.constraints(
			withVisualFormat: "V:[pic]-10-[likes]",
			options: [], metrics: nil,
			views: ["pic": picImg, "likes": likeLbl]))
		
		self.contentView.addConstraints(NSLayoutConstraint.constraints(
			withVisualFormat: "H:|-10-[ava(30)]-10-[username]",
			options: [], metrics: nil,
			views: ["ava": avaImg, "username": usernameBtn]))
		self.contentView.addConstraints(NSLayoutConstraint.constraints(
			withVisualFormat: "H:|-0-[pic]-0-|",
			options: [], metrics: nil,
			views: ["pic": picImg]))
		self.contentView.addConstraints(NSLayoutConstraint.constraints(
			withVisualFormat: "H:|-15-[like(30)]-10-[likes]-20-[comment(30)]",
			options: [], metrics: nil,
			views: ["like": likeBtn, "likes": likeLbl, "comment": commentsBtn]))
		self.contentView.addConstraints(NSLayoutConstraint.constraints(
			withVisualFormat: "H:[more(30)]-15-|",
			options: [], metrics: nil,
			views: ["more": moreBtn]))
		self.contentView.addConstraints(NSLayoutConstraint.constraints(
			withVisualFormat: "H:|-15-[title]-15-|",
			options: [], metrics: nil,
			views: ["title": titleLbl]))
		self.contentView.addConstraints(NSLayoutConstraint.constraints(
			withVisualFormat: "H:|[date]-10-|",
			options: [], metrics: nil,
			views: ["date": dateLbl]))

		avaImg.layer.cornerRadius = avaImg.frame.width / 2
		avaImg.clipsToBounds = true
	}

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
