//
//  FollowerCell.swift
//  Instagram
//
//  Created by brad.wu on 2017/4/17.
//  Copyright © 2017年 bradwoo8621. All rights reserved.
//

import UIKit

class FollowerCell: UITableViewCell {
	@IBOutlet weak var avaImg: UIImageView!
	@IBOutlet weak var usernameLbl: UILabel!
	@IBOutlet weak var followBtn: UIButton!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
