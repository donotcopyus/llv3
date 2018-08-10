//
//  xainzhiTVC.swift
//  llv2
//
//  Created by 林蔼欣 on 2018-07-25.
//  Copyright © 2018 Luna Cao. All rights reserved.
//

//import Foundation
import UIKit
import Firebase

class xianzhiData{
    
    var id: String
    var name: String
    var price: String
    var extraInfo:String
    var timestamp:Double
    var imageOneUrl: String
    var imageTwoUrl: String
    var imageThreeUrl: String
    var author: UserProfile
    
    init(id: String, name:String, price:String, extraInfo:String, timestamp:Double, imageOneUrl:String, imageTwoUrl:String,imageThreeUrl:String, author:UserProfile){
        self.id = id
        self.name = name
        self.price = price
        self.extraInfo = extraInfo
        self.timestamp = timestamp
        self.imageOneUrl = imageOneUrl
        self.imageTwoUrl = imageTwoUrl
        self.imageThreeUrl = imageThreeUrl
        self.author = author
    }
    
}

class xianzhiTVC: UITableViewController{
    
    var arrayOfCellData = [xianzhiData]()
    
    override func viewDidLoad() {
       super.viewDidLoad()
        
        tableView = UITableView()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        
        observePost()
       
    }
    
    
    func observePost(){
        
        let postRef = Database.database().reference().child("xianzhi")
        
        postRef.observe(.value, with:{
            snapshot in
            
            var tempPosts = [xianzhiData]()
            
            for child in snapshot.children{
                if let childSnapshot = child as? DataSnapshot,
                let dict = childSnapshot.value as? [String:Any],
                let author = dict["author"] as? [String:Any],
                let uid = author["uid"] as? String,
                let username = author["username"] as? String,
                let photoURL = author["photoURL"] as? String,
                let url = URL(string:photoURL),
                let name = dict["name"] as? String,
                let price = dict["price"] as? String,
                let extraInfo = dict["extraInfo"] as? String,
                let timestamp = dict["timestamp"] as? Double,
                let imageOneUrl = dict["imageOneUrl"] as? String,
                let imageTwoUrl = dict["imageTwoUrl"] as? String,
                let imageThreeUrl = dict["imageThreeUrl"] as? String
                {
                    let userProfile = UserProfile(uid:uid, username:username, photoURL:url)
                    let post = xianzhiData(id: childSnapshot.key, name: name, price: price, extraInfo: extraInfo, timestamp: timestamp, imageOneUrl: imageOneUrl, imageTwoUrl: imageTwoUrl, imageThreeUrl: imageThreeUrl, author: userProfile)
                    
                    tempPosts.append(post)
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
      //  if arrayOfCellData[indexPath.row].cell == 1 {
            let cell = Bundle.main.loadNibNamed("TableViewCell1", owner: self, options: nil)?.first as! TableViewCell1
        
        if(arrayOfCellData[indexPath.row].imageOneUrl != ""){
           let url1 = URL(string:arrayOfCellData[indexPath.row].imageOneUrl)
           let data1 = try? Data(contentsOf: url1!)
           let image1 = UIImage(data:data1!)
            cell.image1.image = image1
        }
       
        if(arrayOfCellData[indexPath.row].imageTwoUrl != ""){
          let url2 = URL(string:arrayOfCellData[indexPath.row].imageTwoUrl)
          let data2 = try? Data(contentsOf: url2!)
          let image2 = UIImage(data:data2!)
           cell.image2.image = image2
        }

        if(arrayOfCellData[indexPath.row].imageThreeUrl != ""){
          let url3 = URL(string:arrayOfCellData[indexPath.row].imageThreeUrl)
          let data3 = try? Data(contentsOf: url3!)
          let image3 = UIImage(data:data3!)
            cell.image3.image = image3
        }
        
         let url = arrayOfCellData[indexPath.row].author.photoURL
         let data = try? Data(contentsOf:url)
         let image = UIImage(data:data!)
         cell.headImage.image = image


        cell.nameLabel.text = arrayOfCellData[indexPath.row].author.username
        
        let timeInterval = arrayOfCellData[indexPath.row].timestamp / 1000
        let date = NSDate(timeIntervalSince1970: timeInterval)
        let dform = DateFormatter()
        dform.dateFormat = "MM月dd日 HH:mm"
        cell.dateLabel.text = dform.string(from:date as Date)
            
        let nameprice = arrayOfCellData[indexPath.row].name + " 出价:"+arrayOfCellData[indexPath.row].price
        cell.namePrice.text = nameprice
        
        cell.extraInfo.text = arrayOfCellData[indexPath.row].extraInfo

        cell.id.isHidden = true
        cell.id.text = arrayOfCellData[indexPath.row].id
        
        cell.collectionID.isHidden = true

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
        
        cell.authorID.isHidden = true
        cell.authorID.text = arrayOfCellData[indexPath.row].author.uid

            return cell
       // } else
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 165
    }
    
    
    @IBAction func goback(_ sender: UIButton) {
        // self.navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil);
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let viewController = storyboard?.instantiateViewController(withIdentifier: "profileCheckX") as! checkXianzhiController
        let index = tableView.indexPathForSelectedRow?.row
        viewController.pid = arrayOfCellData[index!].id
        viewController.uid = arrayOfCellData[index!].author.uid
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    
    
    
}
