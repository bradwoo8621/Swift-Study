//
//  HomePictureCell.swift
//  Instagram
//
//  Created by brad.wu on 2017/4/14.
//  Copyright © 2017年 bradwoo8621. All rights reserved.
//

import UIKit

class HomePictureCell: UICollectionViewCell {
	@IBOutlet weak var picImg: UIImageView!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		let width = UIScreen.main.bounds.width
		picImg.frame = CGRect(x: 0,
		                      y: 0,
		                      width: width / 3,
		                      height: width / 3)
	}
}
