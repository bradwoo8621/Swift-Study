//
//  HomeViewController.swift
//  Instagram
//
//  Created by brad.wu on 2017/4/14.
//  Copyright © 2017年 bradwoo8621. All rights reserved.
//

import UIKit
import AVOSCloud

class HomeViewController: UICollectionViewController {
	var refresher: UIRefreshControl!
	var page: Int = 12
	var puuidArray = [String]()
	var picArray = [AVFile]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Do any additional setup after loading the view.
		
		self.navigationItem.title = AVUser.current()?.username?.uppercased()
		
		refresher = UIRefreshControl()
		refresher.addTarget(self,
		                    action: #selector(refresh),
		                    for: UIControlEvents.valueChanged)
		collectionView?.addSubview(refresher)
		
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

	func refresh() {
		collectionView?.reloadData()
		refresher.endRefreshing()
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
}
