//
//  UploadViewController.swift
//  Instagram
//
//  Created by brad.wu on 2017/4/25.
//  Copyright © 2017年 bradwoo8621. All rights reserved.
//

import UIKit

class UploadViewController: UIViewController {
	@IBOutlet weak var picImg: UIImageView!
	@IBOutlet weak var titleTxt: UITextView!
	@IBOutlet weak var publishBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
	
	func alignment() {
		let width = self.view.frame.width
		picImg.frame = CGRect(x: 15, y: self.navigationController!.navigationBar.frame.height + 35, width: width / 4.5, height: width / 4.5)
		titleTxt.frame = CGRect(x: picImg.frame.width + 25, y: picImg.frame.origin.y, width: width - titleTxt.frame.origin.x - 10, height: picImg.frame.height)
		publishBtn.frame = CGRect(x: 0, y: self.tabBarController!.tabBar.frame.origin.y - width / 8, width: width, height: width / 8)
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
