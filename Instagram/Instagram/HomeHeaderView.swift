//
//  HomeHeaderView.swift
//  Instagram
//
//  Created by brad.wu on 2017/4/14.
//  Copyright © 2017年 bradwoo8621. All rights reserved.
//

import UIKit

class HomeHeaderView: UICollectionReusableView {
	@IBOutlet weak var avaImg: UIImageView!
	@IBOutlet weak var fullnameLbl: UILabel!
	@IBOutlet weak var webTxt: UITextView!
	@IBOutlet weak var bioLbl: UILabel!
	@IBOutlet weak var postsLbl: UILabel!
	@IBOutlet weak var followerLbl: UILabel!
	@IBOutlet weak var followingLbl: UILabel!
	@IBOutlet weak var postsTitleLbl: UILabel!
	@IBOutlet weak var followerTitleLbl: UILabel!
	@IBOutlet weak var followingTitleLbl: UILabel!
	@IBOutlet weak var button: UIButton!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		let width = UIScreen.main.bounds.width
		
		avaImg.frame = CGRect(x: width / 16,
		                      y: width / 16,
		                      width: width / 4,
		                      height: width / 4)
		postsLbl.frame = CGRect(x: width / 2.5,
		                        y: avaImg.frame.origin.y,
		                        width: 50,
		                        height: 30)
		followerLbl.frame = CGRect(x: width / 1.6,
		                           y: avaImg.frame.origin.y,
		                           width: 50,
		                           height: 30)
		followingLbl.frame = CGRect(x: width / 1.2,
		                            y: avaImg.frame.origin.y,
		                            width: 50,
		                            height: 30)
		postsTitleLbl.center = CGPoint(x: postsLbl.center.x,
		                               y: postsLbl.center.y + 20)
		followerTitleLbl.center = CGPoint(x: followerLbl.center.x,
		                                  y: followerLbl.center.y + 20)
		followingTitleLbl.center = CGPoint(x: followingLbl.center.x,
		                                   y: followingLbl.center.y + 20)
		
		button.frame = CGRect(x: postsTitleLbl.frame.origin.x,
		                      y: postsTitleLbl.center.y + 20,
		                      width: width - postsTitleLbl.frame.origin.x - 10,
		                      height: 30)
		fullnameLbl.frame = CGRect(x: avaImg.frame.origin.x,
		                           y: avaImg.frame.origin.y + avaImg.frame.height,
		                           width: width - 30,
		                           height: 30)
		webTxt.frame = CGRect(x: avaImg.frame.origin.x - 5,
		                      y: fullnameLbl.frame.origin.y + 15,
		                      width: width - 30,
		                      height: 30)
		bioLbl.frame = CGRect(x: avaImg.frame.origin.x,
		                      y: webTxt.frame.origin.y + 30,
		                      width: width - 30,
		                      height: 30)
	}
}
