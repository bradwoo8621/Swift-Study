//
//  ResetPasswordViewController.swift
//  Instagram
//
//  Created by brad.wu on 2017/4/7.
//  Copyright © 2017年 bradwoo8621. All rights reserved.
//

import UIKit
import AVOSCloud

class ResetPasswordViewController: UIViewController {
    @IBOutlet weak var emailTxt: UITextField!

    @IBOutlet weak var resetBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		emailTxt.frame = CGRect(x: 10,
		                        y: 120,
		                        width: self.view.frame.width - 20,
		                        height: 30)
		resetBtn.frame = CGRect(x: 20,
		                        y: emailTxt.frame.origin.y + 50,
		                        width: self.view.frame.width / 4,
		                        height: 30)
		cancelBtn.frame = CGRect(x: self.view.frame.width / 4 * 3 - 20,
		                         y: resetBtn.frame.origin.y,
		                         width: resetBtn.frame.width,
		                         height: 30)
		
		let hideTap = UITapGestureRecognizer(target: self,
		                                     action: #selector(hideKeyboard))
		hideTap.numberOfTapsRequired = 1
		self.view.isUserInteractionEnabled = true
		self.view.addGestureRecognizer(hideTap)
		
		let bg = UIImageView(frame: CGRect(x:0, y:0, width: self.view.frame.width, height: self.view.frame.height))
		bg.image = UIImage(named: "bg.jpg")
		bg.layer.zPosition = -1
		self.view.addSubview(bg)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onResetButtonClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        if emailTxt.text!.isEmpty {
            let alert = UIAlertController(title: "OK",
                                          message: "Fill email",
                                          preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK",
                                   style: .cancel,
                                   handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        AVUser.requestPasswordResetForEmail(inBackground: emailTxt.text!) {(success: Bool, error: Error?) in
            if success {
                let alert = UIAlertController(title: "OK",
                                              message: "Reset Password Email Sent",
                                              preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK",
                                       style: .default,
                                       handler: {(_) in
                    self.dismiss(animated: true, completion: nil)
                })
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            } else {
                print(error!.localizedDescription)
            }
        }
    }

    @IBAction func onCancelButtonClicked(_ sender: UIButton) {
		self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
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
