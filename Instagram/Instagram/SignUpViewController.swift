//
//  SignUpViewController.swift
//  Instagram
//
//  Created by brad.wu on 2017/4/7.
//  Copyright © 2017年 bradwoo8621. All rights reserved.
//

import UIKit
import AVOSCloud

class SignUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
		
		// 定义头像点击事件
		let imgTap = UITapGestureRecognizer(target: self,
		                                    action: #selector(loadImg))
		imgTap.numberOfTapsRequired = 1
		avaImg.isUserInteractionEnabled = true
		avaImg.addGestureRecognizer(imgTap)
		// 让头像变成圆形
		avaImg.layer.cornerRadius = avaImg.frame.width / 2
		avaImg.clipsToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signupButton_clicked(_ sender: UIButton) {
		// 隐藏虚拟键盘
		self.view.endEditing(true)
		
		if usernameTxt.text!.isEmpty
				|| passwordTxt.text!.isEmpty
				|| repeatPasswordTxt.text!.isEmpty
				|| emailTxt.text!.isEmpty
				|| fullnameTxt.text!.isEmpty
				|| bioTxt.text!.isEmpty
				|| webTxt.text!.isEmpty {
			let alert = UIAlertController(title: "Alert",
			                              message: "Fill all fields",
			                              preferredStyle: .alert)
			let ok = UIAlertAction(title: "OK",
			                       style: .cancel,
			                       handler: nil)
			alert.addAction(ok)
			self.present(alert, animated: true, completion: nil)
			return
		}
		
		if passwordTxt.text != repeatPasswordTxt.text {
			let alert = UIAlertController(title: "Alert",
			                              message: "Password mismatch",
			                              preferredStyle: .alert)
			let ok = UIAlertAction(title: "OK",
			                       style: .cancel,
			                       handler: nil)
			alert.addAction(ok)
			self.present(alert, animated: true, completion: nil)
			return
		}
		
		// AVUser是LeanCloud的对象
		let user = AVUser()
		user.username = usernameTxt.text?.lowercased()
		user.email = emailTxt.text?.lowercased()
		user.password = passwordTxt.text
		
		// 以下属性不是AVUser的标准属性, 只能通过[]来添加, 不能直接dot
		user["fullname"] = fullnameTxt.text?.lowercased()
		user["bio"] = bioTxt.text?.lowercased()
		user["web"] = webTxt.text?.lowercased()
		user["gender"] = ""
		// 头像数据
		let avaData = UIImageJPEGRepresentation(avaImg.image!, 0.5)
		let avaFile = AVFile(name: "ava.jpg", data: avaData!)
		user["ava"] = avaFile
		
		// 提交数据
		user.signUpInBackground { (success: Bool, error: Error?) in
			if success {
				print("用户注册成功")
				// 记录用户名
				UserDefaults.standard.set(user.username, forKey: "username")
				// 立刻同步到磁盘上, 如果不调用, 则系统自行决定什么写入到磁盘
				UserDefaults.standard.synchronize()
				let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
				appDelegate.login()
			} else {
				print(error?.localizedDescription as Any)
			}
		}
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
	
	// 响应头像点击事件, 打开相册
	// 需要在Info.plist中增加关于使用照片库的声明
	func loadImg(recognizer: UITapGestureRecognizer) {
		let picker = UIImagePickerController()
		picker.delegate = self
		// 指定来源为照片库
		picker.sourceType = .photoLibrary
		// 指可以编辑
		picker.allowsEditing = true
		present(picker, animated: true, completion: nil)
	}
	
	// 响应选取照片库
	func imagePickerController(_ picker: UIImagePickerController,
	                           didFinishPickingMediaWithInfo info: [String : Any]) {
		// 选择经过裁剪的图像
		avaImg.image = info[UIImagePickerControllerEditedImage] as? UIImage
		// UIImagePickerControllerOriginalImage		// 选择的原始图像, 未经裁剪
		// UIImagePickerContollerMediaURL			// 文件系统中影片的URL
		// UIImagePickerControllerCropRect			// 应用到原始图像当中裁剪的矩形
		// UIImagePikcerControllerMediaType			// 用户选择的图像的类型, 包括kUTTypeImage和kUTTypeMovie
		self.dismiss(animated: true, completion: nil)
	}
	
	// 响应取消选取照片
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
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
