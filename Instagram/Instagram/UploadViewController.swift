//
//  UploadViewController.swift
//  Instagram
//
//  Created by brad.wu on 2017/4/25.
//  Copyright © 2017年 bradwoo8621. All rights reserved.
//

import UIKit
import AVOSCloud

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	@IBOutlet weak var picImg: UIImageView!
	@IBOutlet weak var titleTxt: UITextView!
	@IBOutlet weak var publishBtn: UIButton!
    @IBOutlet weak var removeBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		
		publishBtn.isEnabled = false
		publishBtn.backgroundColor = .lightGray
		removeBtn.isHidden = true
		picImg.image = UIImage(named: "120.png")
		titleTxt.text = ""
		
		let picTap = UITapGestureRecognizer(target: self, action: #selector(selectImg))
		picTap.numberOfTapsRequired = 1
		self.picImg.isUserInteractionEnabled = true
		self.picImg.addGestureRecognizer(picTap)
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		alignment()
	}
	
	func alignment() {
		let width = self.view.frame.width
		let height = self.view.frame.height

		picImg.frame = CGRect(x: 15, y: 15, width: width / 4.5, height: width / 4.5)
		titleTxt.frame = CGRect(x: picImg.frame.width + 25, y: picImg.frame.origin.y, width: width - titleTxt.frame.origin.x - 10, height: picImg.frame.height)
		
		publishBtn.frame = CGRect(x: 0, y: height - width / 8, width: width, height: width / 8)
		removeBtn.frame = CGRect(x: picImg.frame.origin.x, y: picImg.frame.origin.y + picImg.frame.height, width: picImg.frame.width, height: 30)
	}
	
	func selectImg() {
		let picker = UIImagePickerController()
		picker.delegate = self
		picker.sourceType = .photoLibrary
		picker.allowsEditing = true
		present(picker, animated: true, completion: nil)
	}
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		picImg.image = info[UIImagePickerControllerEditedImage] as? UIImage
		self.dismiss(animated: true, completion: nil)
		publishBtn.isEnabled = true
		publishBtn.backgroundColor = UIColor(red: 52.0 / 255.0, green: 169.0 / 255.0, blue: 255.0 / 255.0, alpha: 1)
		removeBtn.isHidden = false
		
		let zoomTap = UITapGestureRecognizer(target: self, action: #selector(zoomImg))
		zoomTap.numberOfTapsRequired = 1
		picImg.isUserInteractionEnabled = true
		picImg.addGestureRecognizer(zoomTap)
	}
	
	func zoomImg() {
		let zoomed = CGRect(x: 0, y: self.view.center.y - self.view.center.x - (self.navigationController?.navigationBar.frame.height)! * 1.5, width: self.view.frame.width, height: self.view.frame.width)
		let unzoomed = CGRect(x: 15, y: 15, width: self.view.frame.width / 4.5, height: self.view.frame.width / 4.5)
		
		if picImg.frame == unzoomed {
			UIView.animate(withDuration: 0.3, animations: {
				self.picImg.frame = zoomed
				self.view.backgroundColor = .black
				self.titleTxt.alpha = 0
				self.publishBtn.alpha = 0
				self.removeBtn.alpha = 0
			})
		} else {
			UIView.animate(withDuration: 0.3, animations: {
				self.picImg.frame = unzoomed
				self.view.backgroundColor = .white
				self.titleTxt.alpha = 1
				self.publishBtn.alpha = 1
				self.removeBtn.alpha = 1
			})
		}
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
    @IBAction func publishBtnClicked(_ sender: UIButton) {
		self.view.endEditing(true)
		let object = AVObject(className: "Posts")
		object["username"] = AVUser.current()?.username
		object["ava"] = AVUser.current()?.value(forKey: "ava") as! AVFile
		object["puuid"] = "\(String(describing: AVUser.current()?.username!)) \(NSUUID().uuidString)"
		
		if titleTxt.text.isEmpty {
			object["title"] = ""
		} else {
			object["title"] = titleTxt.text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
		}
		let imageData = UIImageJPEGRepresentation(picImg.image!, 0.5)
		let imageFile = AVFile(name: "post.jpg", data: imageData!)
		object["pic"] = imageFile
		object.saveInBackground({ (success: Bool, error: Error?) in
			if error == nil {
				NotificationCenter.default.post(name: NSNotification.Name(rawValue: "uploaded"), object: nil)
				self.tabBarController!.selectedIndex = 0
				self.viewDidLoad()
			}
		})
    }

    @IBAction func removeBtnClicked(_ sender: UIButton) {
		self.viewDidLoad()
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
