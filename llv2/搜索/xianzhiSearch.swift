//
//  xianzhiSearch.swift
//  llv2
//
//  Created by Luna Cao on 2018/8/28.
//  Copyright © 2018年 Luna Cao. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

class xianzhiSearchData{
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


class xianzhiSearch: UITableViewController {

    var pidSearchData = [String]()
    var arrayOfCellData = [xianzhiSearchData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        observePost()
        
        
    }
    
    func observePost(){
        
        var tempPosts = [xianzhiSearchData]()
        
        for pid in pidSearchData{
            
            let postRef = Database.database().reference().child("xianzhi/\(pid)")
            
            postRef.observe(.value, with: {snapshot in
                
                if let dict = snapshot.value as? NSDictionary,
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
                    let post = xianzhiSearchData(id: pid, name: name, price: price, extraInfo: extraInfo, timestamp: timestamp, imageOneUrl: imageOneUrl, imageTwoUrl: imageTwoUrl, imageThreeUrl: imageThreeUrl, author: userProfile)
                    
                    tempPosts.append(post)
                    
                    self.arrayOfCellData = tempPosts
                    self.tableView.reloadData()
                    
                    
                }
                
            })
            
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfCellData.count
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //  if arrayOfCellData[indexPath.row].cell == 1 {
        let cell = Bundle.main.loadNibNamed("TableViewCell1", owner: self, options: nil)?.first as! TableViewCell1
        
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.seconds(1), execute: {
            if(self.arrayOfCellData[indexPath.row].imageOneUrl != ""){
                let url1 = URL(string:self.arrayOfCellData[indexPath.row].imageOneUrl)
                cell.image1.kf.indicatorType = .activity
                cell.image1.kf.setImage(with: url1)
            }
            
            if(self.arrayOfCellData[indexPath.row].imageTwoUrl != ""){
                let url2 = URL(string:self.arrayOfCellData[indexPath.row].imageTwoUrl)
                cell.image2.kf.indicatorType = .activity
                cell.image2.kf.setImage(with: url2)
            }
            
            if(self.arrayOfCellData[indexPath.row].imageThreeUrl != ""){
                let url3 = URL(string:self.self.arrayOfCellData[indexPath.row].imageThreeUrl)
                cell.image3.kf.indicatorType = .activity
                cell.image3.kf.setImage(with: url3)
            }
            
            let url = self.arrayOfCellData[indexPath.row].author.photoURL
            
            if (url == URL(string: "default")){
                cell.headImage.image = #imageLiteral(resourceName: "icon.jpg")
            }
            else{
            cell.headImage.kf.indicatorType = .activity
            cell.headImage.kf.setImage(with: url)}
        })
        
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
        
        cell.authorID.isHidden = true
        cell.authorID.text = arrayOfCellData[indexPath.row].author.uid

        
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
        
        
        return cell
        // } else
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 219
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let viewController = storyboard?.instantiateViewController(withIdentifier: "profileCheckX") as! checkXianzhiController
        let index = tableView.indexPathForSelectedRow?.row
        viewController.pid = arrayOfCellData[index!].id
        viewController.uid = arrayOfCellData[index!].author.uid
        
       let navC:UINavigationController = UINavigationController(rootViewController: viewController)
        let backbutton = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(goback))
        backbutton.image = UIImage(named: "backbtn")
        viewController.navigationItem.setLeftBarButton(backbutton, animated: true)
        
        self.present(navC,animated:true)
        
    }

    @objc func goback(){
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

}
