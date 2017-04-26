//
//  PostViewController.swift
//  Instagram
//
//  Created by brad.wu on 2017/4/25.
//  Copyright © 2017年 bradwoo8621. All rights reserved.
//

import UIKit
import AVOSCloud

var postuuid = [String]()

class PostViewController: UITableViewController {
	var avaArray = [AVFile]()
	var usernameArray = [String]()
	var dateArray = [Date]()
	var picArray = [AVFile]()
	var puuidArray = [String]()
	var titleArray = [String]()

	override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
		self.navigationItem.hidesBackButton = true
		let backBtn = UIBarButtonItem(title: "返回", style: .plain, target: self, action: #selector(back(_:)))
		self.navigationItem.leftBarButtonItem = backBtn
		
		let backSwipe = UISwipeGestureRecognizer(target: self, action: #selector(back(_:)))
		backSwipe.direction = .right
		self.view.isUserInteractionEnabled = true
		self.view.addGestureRecognizer(backSwipe)
		
		tableView.rowHeight = UITableViewAutomaticDimension
		tableView.estimatedRowHeight = 450
		let postQuery = AVQuery(className: "Posts")
		postQuery.whereKey("puuid", equalTo: postuuid.last as Any)
		postQuery.findObjectsInBackground({ (objects: [Any]?, error: Error?) in
			self.avaArray.removeAll(keepingCapacity: false)
			self.usernameArray.removeAll(keepingCapacity: false)
			self.dateArray.removeAll(keepingCapacity: false)
			self.picArray.removeAll(keepingCapacity: false)
			self.puuidArray.removeAll(keepingCapacity: false)
			self.titleArray.removeAll(keepingCapacity: false)
			for object in objects! {
				self.avaArray.append((object as AnyObject).value(forKey: "ava") as! AVFile)
				self.usernameArray.append((object as AnyObject).value(forKey: "username") as! String)
				self.dateArray.append((object as AnyObject).createdAt!!)
				self.picArray.append((object as AnyObject).value(forKey: "pic") as! AVFile)
				self.puuidArray.append((object as AnyObject).value(forKey: "puuid") as! String)
				self.titleArray.append((object as AnyObject).value(forKey: "title") as! String)
			}
			self.tableView.reloadData()
		})
    }
	
	func back(_ sender: UIBarButtonItem) {
		_ = self.navigationController?.popViewController(animated: true)
		if !postuuid.isEmpty {
			postuuid.removeLast()
		}
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return usernameArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PostViewCell
		
		cell.usernameBtn.setTitle(usernameArray[indexPath.row], for: .normal)
		cell.usernameBtn.sizeToFit()
		cell.puuidLbl.text = puuidArray[indexPath.row]
		cell.titleLbl.text = titleArray[indexPath.row]
		cell.titleLbl.sizeToFit()
		avaArray[indexPath.row].getDataInBackground({ (data: Data?, error: Error?) in
			cell.avaImg.image = UIImage(data: data!)
		})
		picArray[indexPath.row].getDataInBackground({ (data: Data?, error: Error?) in
			cell.picImg.image = UIImage(data: data!)
		})
		
		let from = dateArray[indexPath.row]
		let now = Date()
		let components : Set<Calendar.Component> = [.second, .minute, .hour, .day, .weekOfMonth]
		let difference = Calendar.current.dateComponents(components, from: from, to: now)
		if difference.second! <= 0 {
			cell.dateLbl.text = "现在"
		} else if difference.minute! <= 0 {
			cell.dateLbl.text = "\(difference.second!)秒"
		} else if difference.hour! <= 0 {
			cell.dateLbl.text = "\(difference.minute!)分"
		} else if difference.day! <= 0 {
			cell.dateLbl.text = "\(difference.hour!)时"
		} else if difference.weekOfMonth! <= 0 {
			cell.dateLbl.text = "\(difference.day!)天"
		} else {
			cell.dateLbl.text = "\(difference.weekOfMonth!)周"
		}

        return cell
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

}
