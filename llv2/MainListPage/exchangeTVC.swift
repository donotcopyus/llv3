//
//  exchangeTVC.swift
//  llv2
//
//  Created by 林蔼欣 on 2018-07-28.
//  Copyright © 2018 Luna Cao. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

struct exchangeData {
    
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

class exchangeTVC: UITableViewController {
    
//*********************************************
    var identities = [String]()
 //****************************************


    
    

    
    @IBOutlet weak var nav: UINavigationItem!
    

    
    var arrayOfCellData = [exchangeData]()
   
    //*********************************************
    override func viewDidLoad() {
        
        
        identities = ["换汇"]
        
        super.viewDidLoad()
        
        tableView = UITableView()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        

        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        
        observePost()
        
        let searchBTN = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(search))
        self.navigationItem.rightBarButtonItem = searchBTN
        
    }
    
    
    func observePost(){
        
        let postRef = Database.database().reference().child("exchange")
        
        postRef.observe(.value, with:{
            snapshot in
            
            var tempPosts = [exchangeData]()
            
            for child in snapshot.children{
                
                if let childSnapshot = child as? DataSnapshot,
                    let dict = childSnapshot.value as? [String:Any],
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
                        let post = exchangeData(id:childSnapshot.key, have:have, want:want, extra:extra, timestamp:timestamp, isCurrency:isCurrency, author:userProfile)
                        
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
        
        
        let cell = Bundle.main.loadNibNamed("TableViewCell3", owner: self, options: nil)?.first as! TableViewCell3
        
        let url = arrayOfCellData[indexPath.row].author.photoURL
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.seconds(2), execute: {
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
        return 73
    }
    
    @IBAction func goback(_ sender: UIButton) {
        // self.navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil);
    }
    
    
    
  //*********************************************
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       
        let viewController = storyboard?.instantiateViewController(withIdentifier: "profileCheckE") as! profileCheckController
        
        let index = tableView.indexPathForSelectedRow?.row
        viewController.pid = arrayOfCellData[index!].id
        viewController.uid = arrayOfCellData[index!].author.uid
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
  
    @objc func search(_ sender: Any) {
        
        performSegue(withIdentifier: "gosearch", sender: self)
    }

}












