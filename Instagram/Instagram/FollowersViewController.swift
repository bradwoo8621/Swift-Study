//
//  FollowersViewController.swift
//  Instagram
//
//  Created by brad.wu on 2017/4/17.
//  Copyright © 2017年 bradwoo8621. All rights reserved.
//

import UIKit
import AVOSCloud

class FollowersViewController: UITableViewController {
	var show = String()
	var user = String()
	var followerArray = [AVUser]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
		
		self.navigationItem.title = show
		if show == "关注者" {
			loadFollowers()
		} else {
			loadFollowings()
		}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
	/*
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
		if followerArray.count != 0 {
			return 1
		} else {
			return 0
		}
    }
	*/

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return followerArray.count
    }

	
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FollowerCell", for: indexPath) as! FollowerCell
		
        // Configure the cell...
		cell.usernameLbl.text = followerArray[indexPath.row].username
		let ava = followerArray[indexPath.row].object(forKey: "ava") as! AVFile
		ava.getDataInBackground({ (data: Data?, error: Error?) in
			if error == nil {
				cell.avaImg.image = UIImage(data: data!)
			} else {
				print(error?.localizedDescription as Any)
			}
		})
		
		let query = followerArray[indexPath.row].followeeQuery()
		query.whereKey("user", equalTo: AVUser.current() as Any)
		query.whereKey("followee", equalTo: followerArray[indexPath.row])
		query.countObjectsInBackground({ (count: Int, error: Error?) in
			if error == nil {
				if count == 0 {
					cell.followBtn.setTitle("关注", for: .normal)
					cell.followBtn.backgroundColor = .lightGray
				} else {
					cell.followBtn.setTitle("已关注", for: .normal)
					cell.followBtn.backgroundColor = .green
				}
			}
		})
		
		cell.user = followerArray[indexPath.row]
		if cell.usernameLbl.text == AVUser.current()?.username {
			cell.followBtn.isHidden = true
		}
        return cell
    }
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let cell = tableView.cellForRow(at: indexPath) as! FollowerCell
		if cell.usernameLbl.text == AVUser.current()?.username {
			let home = storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
			self.navigationController?.pushViewController(home, animated: true)
		} else {
			guestArray.append(followerArray[indexPath.row])
			let guest = storyboard?.instantiateViewController(withIdentifier: "GuestViewController") as! GuestViewController
			self.navigationController?.pushViewController(guest, animated: true)
		}
	}
	
	override func tableView(_ tableView: UITableView,
	                        heightForRowAt indexPath: IndexPath) -> CGFloat {
		return self.view.frame.width / 4
	}

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

	func loadFollowers() {
		AVUser.current()?.getFollowers({ (followers: [Any]?, error: Error?) in
			if error == nil && followers != nil {
				self.followerArray = followers as! [AVUser]
				self.tableView.reloadData()
			} else {
				print(error?.localizedDescription as Any)
			}
		})
	}
	
	func loadFollowings() {
		AVUser.current()?.getFollowees({ (followings: [Any]?, error: Error?) in
			if error == nil && followings != nil {
				self.followerArray = followings as! [AVUser]
				self.tableView.reloadData()
			} else {
				print(error?.localizedDescription as Any)
			}
		})
	}
}
