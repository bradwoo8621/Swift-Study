//
//  GuestViewController.swift
//  Instagram
//
//  Created by brad.wu on 2017/4/17.
//  Copyright © 2017年 bradwoo8621. All rights reserved.
//

import UIKit
import AVOSCloud

var guestArray = [AVUser]()

class GuestViewController: UICollectionViewController {
	var puuidArray = [String]()
	var picArray = [AVFile]()
	var refresher: UIRefreshControl!
	var page: Int = 12

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        // self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
		
		self.collectionView?.alwaysBounceVertical = true
		self.navigationItem.title = guestArray.last?.username
		self.navigationItem.hidesBackButton = true
		let backBtn = UIBarButtonItem(title: "返回",
		                              style: .plain,
		                              target: self,
		                              action: #selector(back(_:)))
		self.navigationItem.leftBarButtonItem = backBtn
		
		let backSwipe = UISwipeGestureRecognizer(target: self,
		                                         action: #selector(back(_:)))
		backSwipe.direction = .right
		self.view.addGestureRecognizer(backSwipe)
		
		refresher = UIRefreshControl()
		refresher.addTarget(self,
		                    action: #selector(refresh),
							for: .valueChanged)
		self.collectionView?.addSubview(refresher)
		
		self.collectionView?.backgroundColor = .white
		
		loadPosts()
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
			if error == nil {
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
			withReuseIdentifier: "HomeHeader",
			for: indexPath) as! HomeHeaderView
		let infoQuery = AVQuery(className: "_User")
		infoQuery.whereKey("username", equalTo: guestArray.last?.username as Any)
		infoQuery.findObjectsInBackground({(objects: [Any]?, error: Error?) in
			if error == nil {
				guard let objects = objects, objects.count > 0 else {return}
				for object in objects {
					header.fullnameLbl.text = ((object as AnyObject).object(forKey: "fullname") as? String)?.uppercased()
					header.bioLbl.text = (object as AnyObject).object(forKey: "bio") as? String
					header.bioLbl.sizeToFit()
					header.webTxt.text = (object as AnyObject).object(forKey: "web") as? String
					header.webTxt.sizeToFit()
					let avaFile = (object as AnyObject).object(forKey: "ava") as? AVFile
					avaFile?.getDataInBackground({(data: Data?, error: Error?) in
						if (error == nil && data != nil) {
							header.avaImg.image = UIImage(data: data!)
						}
					})
				}
			} else {
				print(error?.localizedDescription as Any)
			}
		})
		
		let followeeQuery = AVUser.current()?.followeeQuery()
		followeeQuery?.whereKey("user", equalTo: AVUser.current() as Any)
		followeeQuery?.whereKey("followee", equalTo: guestArray.last as Any)
		followeeQuery?.countObjectsInBackground({(count: Int, error: Error?) in
			guard error == nil else {
				print(error?.localizedDescription as Any)
				return
			}
			
			if count == 0 {
				header.button.setTitle("关注", for: .normal)
				header.button.backgroundColor = .lightGray
			} else {
				header.button.setTitle("已关注", for: .normal)
				header.button.backgroundColor = .green
			}
		})

		let postsQuery = AVQuery(className: "Posts")
		postsQuery.whereKey("username", equalTo: guestArray.last?.username as Any)
		postsQuery.countObjectsInBackground({ (count: Int, error: Error?) in
			if error == nil {
				header.postsLbl.text = "\(count)"
			}
		})
		
		let followersQuery = AVQuery(className: "_Follower")
		followersQuery.whereKey("user", equalTo: guestArray.last as Any)
		followersQuery.countObjectsInBackground({ (count: Int, error: Error?) in
			if error == nil {
				header.followerLbl.text = "\(count)"
			}
		})
		
		let followeesQuery = AVQuery(className: "_Followee")
		followeesQuery.whereKey("user", equalTo: guestArray.last as Any)
		followeesQuery.countObjectsInBackground({ (count: Int, error: Error?) in
			if error == nil {
				header.followingLbl.text = "\(count)"
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
	
	func loadPosts() {
		let query = AVQuery(className: "Posts")
		query.whereKey("username",
		               equalTo: guestArray.last?.username as Any)
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
	
	override func scrollViewDidScroll(_ scrollView: UIScrollView) {
		if scrollView.contentOffset.y >= scrollView.contentSize.height - self.view.frame.height {
			self.loadMore()
		}
	}
	
	func loadMore() {
		if page <= picArray.count {
			page = page + 12
			let query = AVQuery(className: "Posts")
			query.whereKey("username", equalTo: guestArray.last?.username as Any)
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

	func back(_: UIBarButtonItem) {
		self.navigationController?.popViewController(animated: true)
		if !guestArray.isEmpty {
			guestArray.removeLast()
		}
	}
	
	func refresh() {
		self.collectionView?.reloadData()
		self.refresher.endRefreshing()
	}
	
	func postsTap(_ recognizer: UITapGestureRecognizer) {
		if !picArray.isEmpty {
			let index = IndexPath(item: 0,
			                      section: 0)
			self.collectionView?.scrollToItem(at: index,
			                                  at: .top,
			                                  animated: true)
		}
	}
	
	func followersTap(_ recognizer: UITapGestureRecognizer) {
		let followers = self.storyboard?.instantiateViewController(withIdentifier: "FollowersViewController") as! FollowersViewController
		followers.user = (guestArray.last?.username)!
		followers.show = "关注者"
		self.navigationController?.pushViewController(followers, animated: true)
	}
	
	func followingsTap(_ recognizer: UITapGestureRecognizer) {
		let followings = self.storyboard?.instantiateViewController(withIdentifier: "FollowersViewController") as! FollowersViewController
		followings.user = (guestArray.last?.username)!
		followings.show = "关注"
		self.navigationController?.pushViewController(followings, animated: true)
	}
	
	@IBAction func followBtnClicked(_ sender: UIButton) {
		let user = guestArray.last
		let title = sender.title(for: .normal)
		if title == "关注" {
			guard user != nil else {return}
			AVUser.current()?.follow((user?.objectId)!, andCallback: { (success: Bool, error: Error?) in
				if success {
					sender.setTitle("已关注", for: .normal)
					sender.backgroundColor = .green
				} else {
					print(error?.localizedDescription as Any)
				}
			})
		} else {
			guard user != nil else {return}
			AVUser.current()?.unfollow((user?.objectId)!, andCallback: {(success: Bool, error: Error?) in
				if success {
					sender.setTitle("关注", for: .normal)
					sender.backgroundColor = .lightGray
				} else {
					print(error?.localizedDescription as Any)
				}
			})
		}
	}
}
