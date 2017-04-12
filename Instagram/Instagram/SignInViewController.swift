//
//  SignInViewController.swift
//  Instagram
//
//  Created by brad.wu on 2017/4/7.
//  Copyright © 2017年 bradwoo8621. All rights reserved.
//

import UIKit
import AVOSCloud

class SignInViewController: UIViewController {
    // text fields
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    // buttons
    @IBOutlet weak var signinBtn: UIButton!
    @IBOutlet weak var signupBtn: UIButton!
    @IBOutlet weak var forgetBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		let hideTap = UITapGestureRecognizer(target: self,
		                                     action: #selector(hideKeyboard))
		hideTap.numberOfTapsRequired = 1
		self.view.isUserInteractionEnabled = true
		self.view.addGestureRecognizer(hideTap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signInBtn_clicked(_ sender: UIButton) {
        print("登录按钮被单击")
		
		self.view.endEditing(true)
		
		if usernameTxt.text!.isEmpty || passwordTxt.text!.isEmpty {
			let alert = UIAlertController(title: "OK",
			                              message: "Fill all fields",
			                              preferredStyle: .alert)
			let ok = UIAlertAction(title: "OK",
			                       style: .cancel,
			                       handler: nil)
			alert.addAction(ok);
			self.present(alert, animated: true, completion: nil)
			return
		}
		
		AVUser.logInWithUsername(inBackground: usernameTxt.text!,
		                         password: passwordTxt.text!) { (user: AVUser?, error: Error?) in
			if (error == nil) {
				UserDefaults.standard.set(user!.username, forKey: "username")
				UserDefaults.standard.synchronize()
				// 调用login方法
				let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
				appDelegate.login()
			}
		}
    }

	func hideKeyboard(recognizer: UITapGestureRecognizer) {
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
	
}
