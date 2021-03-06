//
//  FollowerCell.swift
//  Instagram
//
//  Created by brad.wu on 2017/4/17.
//  Copyright © 2017年 bradwoo8621. All rights reserved.
//

import UIKit
import AVOSCloud

class FollowerCell: UITableViewCell {
	@IBOutlet weak var avaImg: UIImageView!
	@IBOutlet weak var usernameLbl: UILabel!
	@IBOutlet weak var followBtn: UIButton!
	
	var user:AVUser!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		avaImg.layer.cornerRadius = avaImg.frame.width / 2
		avaImg.clipsToBounds = true
		
		let width = UIScreen.main.bounds.width
		avaImg.frame = CGRect(x: 10,
		                      y: 10,
		                      width: width / 5.3,
		                      height: width / 5.3)
		usernameLbl.frame = CGRect(x: avaImg.frame.width + 20,
		                           y: 30,
		                           width: width / 3.2,
		                           height: 30)
		followBtn.frame = CGRect(x: width - width / 3.5 - 20,
		                         y: 30,
		                         width: width / 3.5,
		                         height: 30)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	@IBAction func followBtnClicked(_ sender: UIButton) {
		let title = followBtn.title(for: .normal)
		if title == "关注" {
			guard user != nil else {return}
			AVUser.current()?.follow(user.objectId!, andCallback: { (success: Bool, error: Error?) in
				if success {
					self.followBtn.setTitle("已关注", for: .normal)
					self.followBtn.backgroundColor = .green
				} else {
					print(error?.localizedDescription as Any)
				}
			})
		} else {
			guard user != nil else {return}
			AVUser.current()?.unfollow(user.objectId!, andCallback: {(success: Bool, error: Error?) in
				if success {
					self.followBtn.setTitle("关注", for: .normal)
					self.followBtn.backgroundColor = .lightGray
				} else {
					print(error?.localizedDescription as Any)
				}
			})
		}
	}
}
