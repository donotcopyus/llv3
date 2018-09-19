//
//  friendTVC.swift
//  llv2
//
//  Created by 林蔼欣 on 2018-09-18.
//  Copyright © 2018 Luna Cao. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher
import ESPullToRefresh

class friendData{
    
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




class friendTVC: UITableViewController {
    
    
    var numberOfPosts: Int = 10
    var arrayOfCellData = [friendData]()
    
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
            
            if(self.numberOfPosts - self.arrayOfCellData.count > 10){
                self.tableView.es.noticeNoMoreData()}
        }}
    
    
    func observePost(){
        
        let postRef = Database.database().reference().child("friend")
        
        postRef.queryLimited(toLast:UInt(numberOfPosts)).observe(.value, with:{
            snapshot in
            
            var tempPosts = [friendData]()
            
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

                        let userProfile = UserProfile(uid:uid, username:username, photoURL:url)
                    let post = friendData(id: childSnapshot.key, address:address, date:date, timestamp: timestamp, imageUrl: imageUrl, info:info, author: userProfile)
                        
                        tempPosts.append(post)
                    
                }
            }
            self.arrayOfCellData = tempPosts.reversed()
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        })
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfCellData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //  if arrayOfCellData[indexPath.row].cell == 1 {
        let cell = Bundle.main.loadNibNamed("friendCell", owner: self, options: nil)?.first as! friendCell

        if(self.arrayOfCellData[indexPath.row].imageUrl != ""){
            let url1 = URL(string:self.arrayOfCellData[indexPath.row].imageUrl)
            cell.image1.kf.indicatorType = .activity
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.seconds(1), execute: {
                cell.image1.kf.setImage(with: url1)
            })
        }
        
        
        let url = self.arrayOfCellData[indexPath.row].author.photoURL
        cell.headImage.kf.indicatorType = .activity
        if (url == URL(string: "default")){
            cell.headImage.image = #imageLiteral(resourceName: "icon.jpg")
        }else{
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.seconds(1), execute: {
                cell.headImage.kf.setImage(with: url)}
            )
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
        cell.id.text = arrayOfCellData[indexPath.row].id
        

        let likedRef = Database.database().reference().child("users/collection/xianzhi/")
        
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
                        cell.likeButton.setTitle("❤️", for: .normal)
                        
                    }}}
            
        })
        
        cell.authorId.isHidden = true
        cell.authorId.text = arrayOfCellData[indexPath.row].author.uid
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 275
        
    }
    
    
    @IBAction func goback(_ sender: UIButton) {
        // self.navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil);
        
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = tableView.indexPathForSelectedRow?.row

//            let viewController = storyboard?.instantiateViewController(withIdentifier: "checkXianzhiNoImageController") as! checkXianzhiNoImageController
//            viewController.pid = arrayOfCellData[index!].id
//            viewController.uid = arrayOfCellData[index!].author.uid
//            self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    
    
    
}
