//
//  vc1.swift
//  llv2
//
//  Created by 林蔼欣 on 2018-08-09.
//  Copyright © 2018 Luna Cao. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher
import ESPullToRefresh

//carpool database object
class carpoolData2{
    
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


class dra1: UITableViewController {

    var arrayOfCellData = [carpoolData2]()
    
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

    
    var numberOfPosts:Int = 5
    var collectionId = [String]()
    
    
    //数据库提取
    func observePost(){
        
        //observe this user's all collection
        let thisUser = Auth.auth().currentUser?.uid
        let collectionRef = Database.database().reference().child("users/collection/carpool")
        
        //collectionpid里储存所有的pid
   collectionRef.observe(.value, with: {
            thissnap in
            
            var collectionPid = [String]()
            var count = 0
            
            for child in thissnap.children{
                if let cS = child as? DataSnapshot,
                let dict = cS.value as? [String:Any],
                let uid = dict["uid"] as? String,
                    let pid = dict["pid"] as? String{
                    if (uid == thisUser) && (count < self.numberOfPosts){
                        collectionPid.append(pid)
                        self.collectionId.append(cS.key)
                        count = count + 1
                    }}}
            
           var tempPosts = [carpoolData2]()
            
            for childPost in collectionPid{
                
                let postRef = Database.database().reference().child("carpool/\(childPost)")
                postRef.observe(.value, with:
                    {snapshot in
                        
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
                            let post = carpoolData2(id: childPost, arrCity: arrCity, depCity: depCity, depTime1: depTime1, depTime2: depTime2, depDate:depDate, remainSeat: remainSeat, timestamp: timestamp, author: userProfile)

                            //append the array
                            tempPosts.append(post)

                            self.arrayOfCellData = tempPosts
                            
                         
                            self.tableView.reloadData()
                             }}
                )
                
            }

        } )
        
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfCellData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("TableViewCell2", owner: self, options: nil)?.first as! TableViewCell2
        
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.seconds(2), execute: {
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
       cell.collectionID.text = collectionId[indexPath.row]


      
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
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    

    
}
