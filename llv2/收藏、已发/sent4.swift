//
//  sent1.swift
//  llv2
//
//  Created by 林蔼欣 on 2018-08-14.
//  Copyright © 2018 Luna Cao. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher
import ESPullToRefresh

//carpool database object
class friendData3{
    
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



class sent4: UITableViewController {
    
    var numberOfPosts:Int = 10
    var arrayOfCellData = [friendData3]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        
        observePost()
        
        self.tableView.es.addInfiniteScrolling {
            [unowned self] in
            
            self.numberOfPosts += 5
            self.observePost()
            
            self.tableView.es.stopLoadingMore()
            
            //需要设置何时到array end？
            if(self.numberOfPosts - self.arrayOfCellData.count > 10){
                self.tableView.es.noticeNoMoreData()}
        }
    }
    
    
    //数据库提取
    func observePost(){
        
        let postRef = Database.database().reference().child("friend")
        
        let thisUser = Auth.auth().currentUser?.uid
        
        postRef.queryLimited(toLast:UInt(numberOfPosts)).observe(.value, with: { snapshot in
            
            var tempPosts = [friendData3]()
            
            for child in snapshot.children{
                
                if let childSnapshot = child as? DataSnapshot,
                    let dict = childSnapshot.value as? [String:Any],
                    let author = dict["author"] as? [String:Any],
                    let uid = author["uid"] as? String,
                    let username = author["username"] as? String,
                    
                    let photoURL = author["photoURL"] as? String,
                    
                    let url = URL(string:photoURL),
                    
                    let address = dict["address"] as? String,
                    let date = dict["date"] as? String,
                    let info = dict["info"] as? String,
                    let timestamp = dict["timestamp"] as? Double,
                    let imageUrl = dict["imageUrl"] as? String
                {
                    
                    if (uid == thisUser){
                        
                        let userProfile = UserProfile(uid:uid, username:username, photoURL:url)
                        let post = friendData3(id: childSnapshot.key, address:address, date:date, timestamp: timestamp, imageUrl: imageUrl, info:info, author: userProfile)
                        
                        
                        //append the array
                        tempPosts.append(post)
                    }
                }
            }
            
            self.arrayOfCellData = tempPosts.reversed()
            self.tableView.reloadData()
        })
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfCellData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("friendCell", owner: self, options: nil)?.first as! friendCell
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.seconds(1), execute: {
            let url = self.arrayOfCellData[indexPath.row].author.photoURL
            
            if (url == URL(string: "default")){
                cell.headImage.image = #imageLiteral(resourceName: "icon.jpg")
            }else{
                cell.headImage.kf.indicatorType = .activity
                cell.headImage.kf.setImage(with: url)
            }})
        
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
        
        cell.likeButton.isHidden = true
        
        return cell
        
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 275
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
//        let viewController = storyboard?.instantiateViewController(withIdentifier: "profileCheckC") as! checkCarpoolController
//
//        let index = tableView.indexPathForSelectedRow?.row
//        viewController.pid = arrayOfCellData[index!].id
//        viewController.uid = arrayOfCellData[index!].author.uid
//        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    
    
}
