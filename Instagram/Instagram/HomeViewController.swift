//
//  HomeViewController.swift
//  Instagram
//
//  Created by brad.wu on 2017/4/14.
//  Copyright © 2017年 bradwoo8621. All rights reserved.
//

import UIKit
import AVOSCloud

class HomeViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
	var refresher: UIRefreshControl!
	var page: Int = 12
	var puuidArray = [String]()
	var picArray = [AVFile]()

    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.collectionView?.alwaysBounceVertical = true

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Do any additional setup after loading the view.
		
		self.navigationItem.title = AVUser.current()?.username?.uppercased()
		
		refresher = UIRefreshControl()
		refresher.addTarget(self,
		                    action: #selector(refresh),
		                    for: UIControlEvents.valueChanged)
		collectionView?.addSubview(refresher)
		
		NotificationCenter.default.addObserver(self, selector: #selector(reload(notification:)), name: NSNotification.Name(rawValue: "reload"), object: loadPosts())
		NotificationCenter.default.addObserver(self, selector: #selector(uploaded(notification:)), name: NSNotification.Name(rawValue: "uploaded"), object: nil)

		loadPosts()
    }
	
	func uploaded(notification: Notification) {
		loadPosts()
	}
	
	func reload(notification: Notification) {
		collectionView?.reloadData()
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource
	
	/*
	// 默认值返回1
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }
	*/

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return picArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCell", for: indexPath) as! HomePictureCell
    
        // Configure the cell
		picArray[indexPath.row].getDataInBackground({(data: Data?, error: Error?) in
			if (error == nil) {
				cell.picImg.image = UIImage(data: data!)
			} else {
				print(error?.localizedDescription as Any)
			}
		})
		
        return cell
    }
	
	override func collectionView(_ collectionView: UICollectionView,
	                             viewForSupplementaryElementOfKind kind: String,
	                             at indexPath: IndexPath) -> UICollectionReusableView {
		let header = self.collectionView?.dequeueReusableSupplementaryView(
			ofKind: UICollectionElementKindSectionHeader,
			withReuseIdentifier: "HomeHeader", for: indexPath) as! HomeHeaderView
		
		header.fullnameLbl.text = (AVUser.current()?.object(forKey: "fullname") as? String)?.uppercased()
		header.webTxt.text = AVUser.current()?.object(forKey: "web") as? String
		header.webTxt.sizeToFit()
		header.bioLbl.text = AVUser.current()?.object(forKey: "bio") as? String
		header.bioLbl.sizeToFit()
		
		let avaQuery = AVUser.current()?.object(forKey: "ava") as! AVFile
		avaQuery.getDataInBackground {(data: Data?, error: Error?) in
			if (data == nil) {
				print(error?.localizedDescription as Any)
			} else {
				header.avaImg.image = UIImage(data: data!)
			}
		}
		
		let currentUser: AVUser = AVUser.current()!
		let postsQuery = AVQuery(className: "Posts")
		postsQuery.whereKey("username", equalTo: currentUser.username as Any)
		postsQuery.countObjectsInBackground({ (count: Int, error: Error?) in
			if error == nil {
				header.postsLbl.text = String(count)
			}
		})
		
		let followersQuery = AVQuery(className: "_Follower")
		followersQuery.whereKey("user", equalTo: currentUser)
		followersQuery.countObjectsInBackground({ (count: Int, error: Error?) in
			if error == nil {
				header.followerLbl.text = String(count)
			}
		})
		
		let followeesQuery = AVQuery(className: "_Followee")
		followeesQuery.whereKey("user", equalTo: currentUser)
		followeesQuery.countObjectsInBackground({ (count: Int, error: Error?) in
			if error == nil {
				header.followingLbl.text = String(count)
			}
		})
		
		let postsTap = UITapGestureRecognizer(target: self,
		                                      action: #selector(postsTap(_:)))
		postsTap.numberOfTapsRequired = 1
		header.postsLbl.isUserInteractionEnabled = true
		header.postsLbl.addGestureRecognizer(postsTap)
		
		let followersTap = UITapGestureRecognizer(target: self,
		                                          action: #selector(followersTap(_:)))
		followersTap.numberOfTapsRequired = 1
		header.followerLbl.isUserInteractionEnabled = true
		header.followerLbl.addGestureRecognizer(followersTap)
		
		let followingsTap = UITapGestureRecognizer(target: self,
		                                           action: #selector(followingsTap(_:)))
		followingsTap.numberOfTapsRequired = 1
		header.followingLbl.isUserInteractionEnabled = true
		header.followingLbl.addGestureRecognizer(followingsTap)
		
		return header
	}
	
	func collectionView(_ collectionView: UICollectionView,
	                    layout collectionViewLayout: UICollectionViewLayout,
	                    sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: self.view.frame.width / 3,
		              height: self.view.frame.width / 3)
	}

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

	func refresh() {
		collectionView?.reloadData()
		refresher.endRefreshing()
	}
	
	override func scrollViewDidScroll(_ scrollView: UIScrollView) {
		if scrollView.contentOffset.y >= scrollView.contentSize.height - self.view.frame.height {
			self.loadMore()
		}
	}
	
	func loadMore() {
		if page <= picArray.count {
			page = page + 12
			let query = AVQuery(className: "Posts")
			query.whereKey("username", equalTo: AVUser.current()?.username as Any)
			query.limit = page
			query.findObjectsInBackground({(objects: [Any]?, error: Error?) in
				if error == nil {
					self.puuidArray.removeAll(keepingCapacity: false)
					self.picArray.removeAll(keepingCapacity: false)
					for object in objects! {
						self.puuidArray.append((object as AnyObject).value(forKey: "puuid") as! String)
						self.picArray.append((object as AnyObject).value(forKey: "pic") as! AVFile)
					}
					print("loaded + \(self.page)")
					self.collectionView?.reloadData()
				} else {
					print(error?.localizedDescription as Any)
				}
			})
		}
	}
	
	func loadPosts() {
		let query = AVQuery(className: "Posts")
		query.whereKey("username",
		               equalTo: AVUser.current()?.username as Any)
		query.limit = page
		query.findObjectsInBackground({(objects: [Any]?, error: Error?) in
			if error == nil {
				self.puuidArray.removeAll(keepingCapacity: false)
				self.picArray.removeAll(keepingCapacity: false)
				for object in objects! {
					self.puuidArray.append((object as AnyObject).value(forKey: "puuid") as! String)
					self.picArray.append((object as AnyObject).value(forKey: "pic") as! AVFile)
				}
				self.collectionView?.reloadData()
			} else {
				print(error?.localizedDescription as Any)
			}
		})
	}
	
	func postsTap(_ recognizer: UITapGestureRecognizer) {
		if !picArray.isEmpty {
			let index = IndexPath(item: 0,
			                      section: 0)
			self.collectionView?.scrollToItem(at: index,
			                                  at: UICollectionViewScrollPosition.top,
			                                  animated: true)
		}
	}
	
	func followersTap(_ recognizer: UITapGestureRecognizer) {
		let followers = self.storyboard?.instantiateViewController(withIdentifier: "FollowersViewController") as! FollowersViewController
		followers.user = (AVUser.current()?.username)!
		followers.show = "关注者"
		self.navigationController?.pushViewController(followers, animated: true)
	}

	func followingsTap(_ recognizer: UITapGestureRecognizer) {
		let followings = self.storyboard?.instantiateViewController(withIdentifier: "FollowersViewController") as! FollowersViewController
		followings.user = (AVUser.current()?.username)!
		followings.show = "关注"
		self.navigationController?.pushViewController(followings, animated: true)
	}
	
	@IBAction func logout(_ sender: UIBarButtonItem) {
		AVUser.logOut()
		UserDefaults.standard.removeObject(forKey: "username")
		UserDefaults.standard.synchronize()
		let signIn = self.storyboard?.instantiateViewController(withIdentifier: "SignInViewController")
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		appDelegate.window?.rootViewController = signIn
	}
}
