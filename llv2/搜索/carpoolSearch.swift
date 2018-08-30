//
//  carpoolSearch.swift
//  llv2
//
//  Created by Luna Cao on 2018/8/28.
//  Copyright © 2018年 Luna Cao. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

class carpoolSearchData{
    var id: String
    var arrCity: String
    var depCity: String
    var depTime1: String
    var depTime2: String
    var depDate: String
    var remainSeat: String
    var timestamp: Double
    var author: UserProfile
    
    init(id:String, arrCity:String, depCity:String, depTime1:String, depTime2:String, depDate:String, remainSeat:String, timestamp:Double, author:UserProfile){
        self.id = id
        self.arrCity = arrCity
        self.depCity = depCity
        self.depTime1 = depTime1
        self.depTime2 = depTime2
        self.depDate = depDate
        self.remainSeat = remainSeat
        self.timestamp = timestamp
        self.author = author
    }
}

class carpoolSearch: UITableViewController {
    
    var pidSearchData = [String]()
    
    var arrayOfCellData = [carpoolSearchData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        observePost()
        
        
    }
    
    func observePost(){
        
        var tempPosts = [carpoolSearchData]()
        
        for pid in pidSearchData{
            
            let postRef = Database.database().reference().child("carpool/\(pid)")
            
            postRef.observe(.value, with: {snapshot in
                
                if let dict = snapshot.value as? NSDictionary,
                    let author = dict["author"] as? [String:Any],
                    let uid = author["uid"] as? String,
                    let username = author["username"] as? String,
                    let photoURL = author["photoURL"] as? String,
                    let url = URL(string:photoURL),
                    let arrCity = dict["arrCity"] as? String,
                    let depCity = dict["depCity"] as? String,
                    let depDate = dict["depDate"] as? String,
                    let depTime1 = dict["depTime1"] as? String,
                    let depTime2 = dict["depTime2"] as? String,
                    let remainSeat = dict["remainSeat"] as? String,
                    let timestamp = dict["timestamp"] as? Double
                {
                    let userProfile = UserProfile(uid:uid, username:username, photoURL:url)
                    let post = carpoolSearchData(id: pid, arrCity: arrCity, depCity: depCity, depTime1: depTime1, depTime2: depTime2, depDate:depDate, remainSeat: remainSeat, timestamp: timestamp, author: userProfile)
                    
                    //append the array
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
    
    // MARK: - Table view data source
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return arrayOfCellData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("TableViewCell2", owner: self, options: nil)?.first as! TableViewCell2
        
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.seconds(1), execute: {
            let url = self.arrayOfCellData[indexPath.row].author.photoURL
            cell.headImage.kf.setImage(with: url)
        })
        
        cell.nameLabel.text = arrayOfCellData[indexPath.row].author.username
        
        
        let timeInterval = arrayOfCellData[indexPath.row].timestamp / 1000
        let date = NSDate(timeIntervalSince1970: timeInterval)
        
        let dform = DateFormatter()
        dform.dateFormat = "MM月dd日 HH:mm"
        
        cell.sendTimeLabel.text = dform.string(from:date as Date)
        
        cell.depatureC.text = arrayOfCellData[indexPath.row].depCity
        
        cell.arriveC.text = arrayOfCellData[indexPath.row].arrCity
        
        cell.date.text = arrayOfCellData[indexPath.row].depDate
        
        cell.time1.text = arrayOfCellData[indexPath.row].depTime1
        
        cell.time2.text = arrayOfCellData[indexPath.row].depTime2
        
        cell.seatLabel.text = arrayOfCellData[indexPath.row].remainSeat
        
        cell.id.isHidden = true
        cell.collectionID.isHidden = true
        
        cell.id.text = arrayOfCellData[indexPath.row].id
        
        
        let likedRef = Database.database().reference().child("users/collection/carpool/")
        
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
                        cell.likedButton.setTitle("❤️", for: .normal)
                        
                    }}}
            
        })
        
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 101.5
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let viewController = storyboard?.instantiateViewController(withIdentifier: "profileCheckC") as! checkCarpoolController
        
        let index = tableView.indexPathForSelectedRow?.row
        viewController.pid = arrayOfCellData[index!].id
        viewController.uid = arrayOfCellData[index!].author.uid
        
         let navC:UINavigationController = UINavigationController(rootViewController: viewController)
        
        self.present(navC, animated: true)
        
    }
    
}
