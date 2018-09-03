//
//  checkCarpoolController.swift
//  llv2
//
//  Created by Luna Cao on 2018/8/9.
//  Copyright © 2018年 Luna Cao. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

class checkCarpoolController: UIViewController {
    
    @IBOutlet weak var pidLabel: UILabel!
    @IBOutlet weak var uidLabel: UILabel!
    @IBOutlet weak var headImage: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var route: UILabel!
    @IBOutlet weak var seat: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var depTime: UILabel!
    
    @IBOutlet weak var chat: UIButton!
    
    @IBOutlet weak var imageurl: UILabel!
    @IBOutlet weak var delete: UIButton!
    
    var pid = String()
    var uid = String()

//    @IBAction func back(_ sender: UIButton) {
//        self.dismiss(animated: true, completion: nil)
//    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        headImage.layer.cornerRadius = headImage.frame.height / 2.0
        headImage.layer.masksToBounds = true
        //get pid，藏起来
        self.pidLabel.isHidden = true
        self.pidLabel.text = pid
        self.uidLabel.isHidden = true
        self.uidLabel.text = uid
        self.imageurl.isHidden = true
        
        //如果是自己，没办法chat
        if (uidLabel.text == Auth.auth().currentUser!.uid){
            self.chat.isHidden = true
        }
        else{
 
            self.delete.isHidden = true
        }
        
        let postRef = Database.database().reference().child("carpool/\(pid)")
        
        postRef.observe(DataEventType.value, with:{
            (snapshot) in
            if let post = snapshot.value as? [String:Any]{
                let author = post["author"] as? [String:Any]
            
         DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.seconds(1), execute: {
            let url = author!["photoURL"] as? String
                        self.imageurl.text = url
            let tourl = URL(string:url!)
            self.headImage.kf.setImage(with: tourl)
             })
                
            self.username.text = author!["username"] as? String
            
                let timeInterval = (post["timestamp"] as? Double)! / 1000
            let date = NSDate(timeIntervalSince1970: timeInterval)
            let dform = DateFormatter()
            dform.dateFormat = "MM月dd日 HH:mm"
            
            self.time.text = "发送于：" + dform.string(from:date as Date)
            
                let arr = post["arrCity"] as? String
                let dep = post["depCity"] as? String
            let fullstring = "从" + dep! + ", 到" + arr!
            self.route.text = fullstring
            
                self.seat.text = "剩余座位：" + (post["remainSeat"] as? String)!
            
                self.date.text = "出发日期：" + (post["depDate"] as? String)!
            
                self.depTime.text = "大致出发时间：" + (post["depTime1"] as? String)! + " ~ " + (post["depTime2"] as? String)!
            }
        })

    }
    
    @IBAction func chat(_ sender: UIButton) {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "chatLog") as! ChatLogController
        
        viewController.uid = uid
        viewController.username = self.username.text!
        viewController.url = self.imageurl.text!
        self.navigationController?.pushViewController(viewController, animated: true)

    }
    
    @IBAction func deletepost(_ sender: UIButton) {
        
        let postRef = Database.database().reference().child("carpool/\(pid)")
        
        let alert = UIAlertController(title: "删除广告", message: "确定删除广告吗？", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (action: UIAlertAction!) in
            postRef.removeValue()
            
            let likedRef = Database.database().reference().child("users/collection/carpool/")
            
            likedRef.observeSingleEvent(of: .value, with: {
                snapshot in
                
                for child in snapshot.children{
                    if let childSnapshot = child as? DataSnapshot,
                        let dict = childSnapshot.value as? [String:Any],
                        let thispid = dict["pid"] as? String{
                        
                        if (thispid == self.pid){
                            let userLikeRef = Database.database().reference().child("users/collection/carpool/\(childSnapshot.key)")
                            userLikeRef.removeValue()
                        }
                        
                    }
                }
                
            })
            
            
            self.dismiss(animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (action: UIAlertAction!) in
            //啥也不做！
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func share(_ sender: Any) {
        let activityVC = UIActivityViewController(activityItems: ["www.google.ca"], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        
        self.present(activityVC, animated: true, completion: nil)
    }

}
