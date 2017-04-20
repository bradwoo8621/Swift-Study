//
//  EditViewController.swift
//  Instagram
//
//  Created by brad.wu on 2017/4/20.
//  Copyright © 2017年 bradwoo8621. All rights reserved.
//

import UIKit
import AVOSCloud

class EditViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	@IBOutlet weak var scrollView: UIScrollView!
	@IBOutlet weak var avaImg: UIImageView!
	@IBOutlet weak var fullnameTxt: UITextField!
	@IBOutlet weak var usernameTxt: UITextField!
	@IBOutlet weak var webTxt: UITextField!
	@IBOutlet weak var bioTxt: UITextView!
	@IBOutlet weak var titleLbl: UILabel!
	@IBOutlet weak var emailTxt: UITextField!
	@IBOutlet weak var telTxt: UITextField!
	@IBOutlet weak var genderTxt: UITextField!
	
	var genderPicker: UIPickerView!
	let genders = ["男", "女"]
	var keyboard = CGRect()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		genderPicker = UIPickerView()
		genderPicker.dataSource = self
		genderPicker.delegate = self
		genderPicker.backgroundColor = UIColor.groupTableViewBackground
		genderPicker.showsSelectionIndicator = true
		genderTxt.inputView = genderPicker
		
		NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard), name: Notification.Name.UIKeyboardWillShow, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard), name: Notification.Name.UIKeyboardWillHide, object: nil)
		let hideTap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardTap))
		hideTap.numberOfTapsRequired = 1
		self.view.isUserInteractionEnabled = true
		self.view.addGestureRecognizer(hideTap)
		
		let imgTap = UITapGestureRecognizer(target: self, action: #selector(loadImg))
		imgTap.numberOfTapsRequired = 1
		avaImg.isUserInteractionEnabled = true
		avaImg.addGestureRecognizer(imgTap)

		alignment()
		information()
    }
	
	func alignment() {
		let width = self.view.frame.width
		let height = self.view.frame.height
		scrollView.frame = CGRect(x: 0, y: 0, width: width, height: height)
		avaImg.frame = CGRect(x: width - 68 - 10, y: 15, width: 68, height: 68)
		avaImg.layer.cornerRadius = avaImg.frame.width / 2
		avaImg.clipsToBounds = true
		fullnameTxt.frame = CGRect(x: 10, y: avaImg.frame.origin.y, width: width - avaImg.frame.width - 30, height: 30)
		usernameTxt.frame = CGRect(x: 10, y: fullnameTxt.frame.origin.y + 40, width: width - avaImg.frame.width - 30, height: 30)
		webTxt.frame = CGRect(x: 10, y: usernameTxt.frame.origin.y + 40, width: width - 20, height: 30)
		bioTxt.frame = CGRect(x: 10, y: webTxt.frame.origin.y + 40, width: width - 20, height: 60)
		bioTxt.layer.borderWidth = 1
		bioTxt.layer.borderColor = UIColor(red: 230 / 255.0, green: 230 / 255.0, blue: 230 / 255.0, alpha: 1).cgColor
		bioTxt.layer.cornerRadius = bioTxt.frame.width / 50
		bioTxt.clipsToBounds = true
		
		titleLbl.frame = CGRect(x: 10, y: bioTxt.frame.origin.y + 100, width: width - 20, height: 30)
		emailTxt.frame = CGRect(x: 10, y: titleLbl.frame.origin.y + 40, width: width - 20, height: 30)
		telTxt.frame = CGRect(x: 10, y: emailTxt.frame.origin.y + 40, width: width - 20, height: 30)
		genderTxt.frame = CGRect(x: 10, y: telTxt.frame.origin.y + 40, width: width - 20, height: 30)
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func information() {
		let ava = AVUser.current()?.object(forKey: "ava") as! AVFile
		ava.getDataInBackground({ (data: Data?, error: Error?) in
			if error == nil {
				self.avaImg.image = UIImage(data: data!)
			} else {
				print(error?.localizedDescription as Any)
			}
		})
		usernameTxt.text = AVUser.current()?.username
		fullnameTxt.text = AVUser.current()?.object(forKey: "fullname") as? String
		bioTxt.text = AVUser.current()?.object(forKey: "bio") as? String
		webTxt.text = AVUser.current()?.object(forKey: "web") as? String
		emailTxt.text = AVUser.current()?.email
		telTxt.text = AVUser.current()?.mobilePhoneNumber
		genderTxt.text = AVUser.current()?.object(forKey: "gender") as? String
	}
	
	func hideKeyboardTap(recogziner: UITapGestureRecognizer) {
		self.view.endEditing(true)
	}
	
	func showKeyboard(notification: Notification) {
		let rect = notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
		keyboard = rect.cgRectValue
		UIView.animate(withDuration: 0.4) {
			self.scrollView.contentSize.height = self.view.frame.height + self.keyboard.height / 2
		}
	}
	
	func hideKeyboard(notification: Notification) {
		UIView.animate(withDuration: 0.4) {
			self.scrollView.contentSize.height = 0
		}
	}
	
	func loadImg(recognizer: UITapGestureRecognizer) {
		let picker = UIImagePickerController()
		picker.delegate = self
		picker.sourceType = .photoLibrary
		picker.allowsEditing = true
		present(picker, animated: true, completion: nil)
	}
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		avaImg.image = info[UIImagePickerControllerEditedImage] as? UIImage
		self.dismiss(animated: true, completion: nil)
	}
	
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return genders.count
	}
	
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return genders[row]
	}
	
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		genderTxt.text = genders[row]
		self.view.endEditing(true)
	}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
	
	@IBAction func cancelClicked(_ sender: UIBarButtonItem) {
		self.view.endEditing(true)
		self.dismiss(animated: true, completion: nil)
	}

	@IBAction func saveClicked(_ sender: UIBarButtonItem) {
	}
}
