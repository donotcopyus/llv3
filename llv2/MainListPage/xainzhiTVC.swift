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
import Kingfisher
import ESPullToRefresh

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
    
    @IBOutlet weak var btnMenu: UIBarButtonItem!
    
//    var b2 = dropDownBtn()

    var numberOfPosts: Int = 5
    var arrayOfCellData = [xianzhiData]()
    
    override func viewDidLoad() {
       super.viewDidLoad()
        
//        b2 = dropDownBtn.init(frame: CGRect(x:0, y:81, width: 150, height: 31))
//
//        b2.setTitle("选择类型", for: .normal)
//
//        b2.translatesAutoresizingMaskIntoConstraints = true
//
//        b2.dropView.dropDownOptions = ["书","药妆","家具","租房","服饰","其他"]
        
//        self.view.addSubview(b2)
      
//        if self.revealViewController() != nil{
//            btnMenu.target = self.revealViewController()
//            btnMenu.action = #selector(SWRevealViewController.rightRevealToggle(_:))
//            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
//
//
//        }
        
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
    
    
    func observePost(){
        
        let postRef = Database.database().reference().child("xianzhi")
        
        postRef.queryLimited(toLast:UInt(numberOfPosts)).observe(.value, with:{
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
                let url3 = URL(string:self.arrayOfCellData[indexPath.row].imageThreeUrl)
                cell.image3.kf.indicatorType = .activity
            cell.image3.kf.setImage(with: url3)
        }
        
            let url = self.arrayOfCellData[indexPath.row].author.photoURL
            cell.headImage.kf.indicatorType = .activity
         cell.headImage.kf.setImage(with: url)
            
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
        return 219
    }
    
    
    @IBAction func goback(_ sender: UIButton) {
        // self.navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil);
    }
    
    

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = tableView.indexPathForSelectedRow?.row
        let image1 = arrayOfCellData[index!].imageOneUrl
        let image2 = arrayOfCellData[index!].imageTwoUrl
        let image3 = arrayOfCellData[index!].imageThreeUrl
        
        if(image1 != "" && image2 != "" && image3 != ""){
        let viewController = storyboard?.instantiateViewController(withIdentifier: "profileCheckX") as! checkXianzhiController
        viewController.pid = arrayOfCellData[index!].id
        viewController.uid = arrayOfCellData[index!].author.uid
        self.navigationController?.pushViewController(viewController, animated: true)
        }
        
        else if (image1 != "" && image3 != "" && image2 == ""){
            let viewController = storyboard?.instantiateViewController(withIdentifier: "two") as! checkXianzhi2Controller
            viewController.pid = arrayOfCellData[index!].id
            viewController.uid = arrayOfCellData[index!].author.uid
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        
        else if (image1 != "" && image2 == "" && image3 == ""){
            let viewController = storyboard?.instantiateViewController(withIdentifier: "checkXianzhi1Controller") as! checkXianzhi1Controller
            viewController.pid = arrayOfCellData[index!].id
            viewController.uid = arrayOfCellData[index!].author.uid
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        
        else if (image1 == "" && image2 == "" && image3 == ""){
            let viewController = storyboard?.instantiateViewController(withIdentifier: "checkXianzhiNoImageController") as! checkXianzhiNoImageController
            viewController.pid = arrayOfCellData[index!].id
            viewController.uid = arrayOfCellData[index!].author.uid
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        
        
        
    }
    

    
    
}
