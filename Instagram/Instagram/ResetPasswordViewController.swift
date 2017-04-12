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
        self.dismiss(animated: true, completion: nil)
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
