//
//  friendSearch.swift
//  llv2
//
//  Created by Luna Cao on 2018/9/20.
//  Copyright © 2018年 Luna Cao. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

class friendSearchData{
    
    var id:String
    var address: String
    var date: String
    var timestamp:Double
    var imageUrl: String
    var info: String
    var author: UserProfile
    
    init(id:String, address:String, date:String, timestamp:Double, imageUrl:String, info:String, author:UserProfile){
        self.id = id
        self.address = address
        self.date = date
        self.timestamp = timestamp
        self.imageUrl = imageUrl
        self.info = info
        self.author = author
    }
    
}

class friendSearch: UITableViewController {
    
    var pidSearchData = [String]()
    
    var arrayOfCellData = [friendSearchData]()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView = UITableView()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()

        observePost()
    }

    func observePost(){
        
        var tempPosts = [friendSearchData]()
        
        for pid in pidSearchData{
            let postRef = Database.database().reference().child("friend/\(pid)")
            
            postRef.observe(.value, with: {snapshot in
                
                if let dict = snapshot.value as? NSDictionary,
                    let author = dict["author"] as? [String:Any],
                    let uid = author["uid"] as? String,
                    let username = author["username"] as? String,
                    
                    let photoURL = author["photoURL"] as? String,
                    
                    let url = URL(string:photoURL),
                    
                    let address = dict["address"] as? String,
                    let date = dict["date"] as? String,
                    let info = dict["info"] as? String,
                    let timestamp = dict["timestamp"] as? Double,
                    let imageUrl = dict["imageUrl"] as? String{
                    
                    let userProfile = UserProfile(uid:uid, username:username, photoURL:url)
                    let post = friendSearchData(id: pid, address:address, date:date, timestamp: timestamp, imageUrl: imageUrl, info:info, author: userProfile)
                    
                    tempPosts.append(post)
                    self.arrayOfCellData = tempPosts
                    self.tableView.reloadData()
                }
            })
            
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return arrayOfCellData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = Bundle.main.loadNibNamed("friendCell", owner: self, options: nil)?.first as! friendCell
        
        let url = self.arrayOfCellData[indexPath.row].author.photoURL
        if (url == URL(string: "default")){
            cell.headImage.image = #imageLiteral(resourceName: "icon.jpg")
        }
        else{
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.seconds(1), execute: {

            cell.headImage.kf.indicatorType = .activity
            cell.headImage.kf.setImage(with: url)
        })}
        
        if(self.arrayOfCellData[indexPath.row].imageUrl != ""){
            let url1 = URL(string:self.arrayOfCellData[indexPath.row].imageUrl)
            cell.image1.kf.indicatorType = .activity
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.seconds(1), execute: {
                cell.image1.kf.setImage(with: url1)
            })
        }
        
        cell.nameLabel.text = arrayOfCellData[indexPath.row].author.username
        
        
        let timeInterval = arrayOfCellData[indexPath.row].timestamp / 1000
        let date = NSDate(timeIntervalSince1970: timeInterval)
        
        let dform = DateFormatter()
        dform.dateFormat = "MM月dd日 HH:mm"
        
        cell.senttime.text = dform.string(from:date as Date)
        
        cell.namePrice.text = arrayOfCellData[indexPath.row].date
        cell.address.text = arrayOfCellData[indexPath.row].address
        cell.info.text = arrayOfCellData[indexPath.row].info
        
        cell.id.isHidden = true
        cell.collectionID.isHidden = true
        
        cell.id.text = arrayOfCellData[indexPath.row].id
 
        
        let likedRef = Database.database().reference().child("users/collection/friend/")
        
        let uid = Auth.auth().currentUser?.uid
        
        let pid = arrayOfCellData[indexPath.row].id
        
        likedRef.observeSingleEvent(of:.value, with:{
            snapshot in
            
            for child in snapshot.children{
                if let childSnapshot = child as? DataSnapshot,
                    let dict = childSnapshot.value as? [String:Any],
                    let thispid = dict["pid"] as? String,
                    let thisuid = dict["uid"] as? String{
                    
                    //如果已经被like
                    if(thisuid == uid && thispid == pid){
                   cell.likeButton.setImage(UIImage(named:"liked"), for: .normal)
                        
                    }}}
            
        })
        
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 275
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let viewController = storyboard?.instantiateViewController(withIdentifier: "friendV") as! checkFriendVC
        
        let index = tableView.indexPathForSelectedRow?.row
        viewController.pid = arrayOfCellData[index!].id
        viewController.uid = arrayOfCellData[index!].author.uid
        self.navigationController?.pushViewController(viewController, animated: true)
    }
 
}
