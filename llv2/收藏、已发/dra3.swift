//
//  dra3.swift
//  llv2
//
//  Created by 林蔼欣 on 2018-08-13.
//  Copyright © 2018 Luna Cao. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher
import ESPullToRefresh

struct exchangeData2 {
    
    var id: String
    var have: String
    var want: String
    var extra: String
    var timestamp: Double
    var isCurrency: Bool
    var author: UserProfile
    
    init(id:String, have:String, want:String, extra:String, timestamp:Double, isCurrency:Bool,author:UserProfile){
        self.id = id
        self.have = have
        self.want = want
        self.extra = extra
        self.isCurrency = isCurrency
        self.timestamp = timestamp
        self.author = author
    }
    
}

class dra3: UITableViewController {
    
    @IBOutlet weak var nav: UINavigationItem!
    
    var arrayOfCellData = [exchangeData2]()
    
    override func viewDidLoad() {

        
        super.viewDidLoad()
        
        tableView = UITableView()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        
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
    
    func observePost(){
        
        //observe this user's all collection
        let thisUser = Auth.auth().currentUser?.uid
        let collectionRef = Database.database().reference().child("users/collection/exchange")
        
        collectionRef.observe(.value, with:{
            thissnap in
            
            var count = 0
            var collectionPid = [String]()
            
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
           
            var tempPosts = [exchangeData2]()
            
            for childPost in collectionPid{
                let postRef = Database.database().reference().child("exchange/\(childPost)")
            
                postRef.observe(.value, with: { (snapshot) in
                    
                    if let dict = snapshot.value as? NSDictionary,
                        let author = dict["author"] as? [String:Any],
                        let uid = author["uid"] as? String,
                        let username = author["username"] as? String,
                        
                        let photoURL = author["photoURL"] as? String,
                        
                        let url = URL(string:photoURL),
                        
                        
                        let have = dict["haveMoney"] as? String,
                        let want = dict["wantMoney"] as? String,
                        let extra = dict["extraInfo"] as? String,
                        let timestamp = dict["timestamp"] as? Double,
                        let isCurrency = dict["currencyBol"] as? Bool
                    {
                        
                        let userProfile = UserProfile(uid:uid, username:username, photoURL:url)
                        let post = exchangeData2(id:childPost, have:have, want:want, extra:extra, timestamp:timestamp, isCurrency:isCurrency, author:userProfile)
                        
                        tempPosts.append(post)
                        self.arrayOfCellData = tempPosts
                        self.tableView.reloadData()
                    }})
            }})
}
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfCellData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = Bundle.main.loadNibNamed("TableViewCell3", owner: self, options: nil)?.first as! TableViewCell3
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.seconds(1), execute: {
            let url = self.arrayOfCellData[indexPath.row].author.photoURL

        cell.mainimage.kf.setImage(with: url)
        })
        cell.mainlabel.text = arrayOfCellData[indexPath.row].author.username
        
        let timeInterval = arrayOfCellData[indexPath.row].timestamp / 1000
        let date = NSDate(timeIntervalSince1970: timeInterval)
        
        let dform = DateFormatter()
        dform.dateFormat = "MM月dd日 HH:mm"
        
        cell.sendtimelb.text = dform.string(from:date as Date)
        
        let stringTemp = "出" + arrayOfCellData[indexPath.row].have + " " + "求" + arrayOfCellData[indexPath.row].want
        
        cell.detaillb.text = stringTemp
        
        cell.extraInformartion.text = arrayOfCellData[indexPath.row].extra
        
        if (arrayOfCellData[indexPath.row].isCurrency == true){
            cell.isCur.isHidden = false
        }
        else{
            cell.isCur.isHidden = true
        }
        
        
        cell.id.isHidden = true
        cell.id.text = arrayOfCellData[indexPath.row].id
        
        cell.collectionID.isHidden = true
        
        cell.collectionID.text = collectionId[indexPath.row]
        
        let likedRef = Database.database().reference().child("users/collection/exchange/")
        
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
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    
    
    //*********************************************
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let viewController = storyboard?.instantiateViewController(withIdentifier: "profileCheckE") as! profileCheckController
        
        let index = tableView.indexPathForSelectedRow?.row
        viewController.pid = arrayOfCellData[index!].id
        viewController.uid = arrayOfCellData[index!].author.uid
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    
}












