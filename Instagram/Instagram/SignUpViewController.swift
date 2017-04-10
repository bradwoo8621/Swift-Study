//
//  SignUpViewController.swift
//  Instagram
//
//  Created by brad.wu on 2017/4/7.
//  Copyright © 2017年 bradwoo8621. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    // Image View, 头像
    @IBOutlet weak var avaImg: UIImageView!
    // Text Fields
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var repeatPasswordTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var fullnameTxt: UITextField!
    @IBOutlet weak var bioTxt: UITextField!
    @IBOutlet weak var webTxt: UITextField!
    // Scroll View
    @IBOutlet weak var scrollView: UIScrollView!
    // 根据需要, 设置Scroll的高度
    var scrollViewHeight: CGFloat = 0
    var keyboard: CGRect = CGRect()
    // Buttons
    @IBOutlet weak var signupBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // scroll view 的窗口尺寸
        scrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        // or as below, 设置成为主屏幕的尺寸
        // scrollView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        scrollView.contentSize.height = self.view.frame.height
        scrollViewHeight = self.view.frame.height
        
        // 检测键盘出现或者消失状态
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(showKeyboard),
                                               name: Notification.Name.UIKeyboardWillShow,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(hideKeyboard),
                                               name: Notification.Name.UIKeyboardWillHide,
                                               object: nil)
        
        // 定义隐藏虚拟键盘操作
        let hideTap = UITapGestureRecognizer(target: self,
                                             action: #selector(hideKeyboardTap))
        // 只需要点击一次
        hideTap.numberOfTapsRequired = 1
        // 将当前视图开放用户操作
        self.view.isUserInteractionEnabled = true
        // 添加事件监听
        self.view.addGestureRecognizer(hideTap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signupButton_clicked(_ sender: UIButton) {
    }

    @IBAction func cancelButton_clicked(_ sender: UIButton) {
        // 动画方式去除通过modally方式添加的控制器
        self.dismiss(animated: true, completion: nil)
    }
    
    func showKeyboard(notification: Notification) {
        // 定义keyboard尺寸
        let rect = notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        keyboard = rect.cgRectValue
        
        // 虚拟键盘出现以后, 将视图实际高度缩小为屏幕高度减去键盘的高度
        UIView.animate(withDuration: 0.4) {
			print(self.scrollViewHeight)
			print(self.keyboard.size.height)
            self.scrollView.frame.size.height = self.scrollViewHeight - self.keyboard.size.height
			print(self.scrollView.frame.size.height)
        }
    }
    
    func hideKeyboard(notification: Notification) {
        // 虚拟键盘消失后, 将视图实际高度修改为屏幕高度
        UIView.animate(withDuration: 0.4) { 
            self.scrollView.frame.size.height = self.view.frame.height
        }
    }
    
    // 响应当前视图点击事件, 隐藏虚拟键盘
    func hideKeyboardTap(recognizer: UITapGestureRecognizer) {
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