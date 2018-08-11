//
//  checkXianzhiController.swift
//  llv2
//
//  Created by Luna Cao on 2018/8/10.
//  Copyright © 2018年 Luna Cao. All rights reserved.
//

import UIKit
import Firebase

class checkXianzhiController: UIViewController {
    
    @IBAction func back(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var pidLabel: UILabel!
    @IBOutlet weak var uidLabel: UILabel!
    
    @IBOutlet weak var headImage: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image3: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var info: UILabel!
    @IBOutlet weak var chat: UIButton!
    @IBOutlet weak var edit: UIButton!
    @IBOutlet weak var delete: UIButton!
    
    
    var pid = String()
    var uid = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pictureTap1 = UITapGestureRecognizer(target: self, action: #selector(checkXianzhiController.imageTapped))
        let pictureTap2 = UITapGestureRecognizer(target: self, action: #selector(checkXianzhiController.imageTapped))
        let pictureTap3 = UITapGestureRecognizer(target: self, action: #selector(checkXianzhiController.imageTapped))

        
        //get pid，藏起来
        self.pidLabel.isHidden = true
        self.pidLabel.text = pid
        self.uidLabel.isHidden = true
        self.uidLabel.text = uid
        
        //如果是自己，没办法chat
        if (uidLabel.text == Auth.auth().currentUser!.uid){
            self.chat.isHidden = true
        }
        else{
            self.edit.isHidden = true
            self.delete.isHidden = true
        }
        
         let postRef = Database.database().reference().child("xianzhi/\(pid)")
        
        postRef.observe(DataEventType.value, with:{
            (snapshot) in
            let post = snapshot.value as? [String:Any]
            let author = post!["author"] as? [String:Any]
            
            let url = author!["photoURL"] as? String
            let tourl = URL(string:url!)
            let data = try? Data(contentsOf: tourl!)
            self.headImage.image = UIImage(data:data!)
            
            self.username.text = author!["username"] as? String
            
            let timeInterval = (post!["timestamp"] as? Double)! / 1000
            let date = NSDate(timeIntervalSince1970: timeInterval)
            let dform = DateFormatter()
            dform.dateFormat = "MM月dd日 HH:mm"
            
            self.time.text = "发送于：" + dform.string(from:date as Date)
            
            let url1 = post!["imageOneUrl"] as? String
            if (url1 != ""){
            let tourl1 = URL(string:url1!)
            let data1 = try?Data(contentsOf:tourl1!)
                self.image1.image = UIImage(data:data1!)
                self.image1.addGestureRecognizer(pictureTap1)
                self.image1.isUserInteractionEnabled = true
            }
            
            let url2 = post!["imageTwoUrl"] as? String
            if (url2 != ""){
                let tourl2 = URL(string:url2!)
                let data2 = try?Data(contentsOf:tourl2!)
                self.image2.image = UIImage(data:data2!)
                self.image2.addGestureRecognizer(pictureTap2)
                self.image2.isUserInteractionEnabled = true
            }
            
            let url3 = post!["imageThreeUrl"] as? String
            if (url3 != ""){
                let tourl3 = URL(string:url3!)
                let data3 = try?Data(contentsOf:tourl3!)
                self.image3.image = UIImage(data:data3!)
                self.image3.addGestureRecognizer(pictureTap3)
                self.image3.isUserInteractionEnabled = true
            }
            
            self.name.text = "物品： " + (post!["name"] as? String)!
            self.price.text = "价格： " + (post!["price"] as? String)!
            
            self.info.text = post!["extraInfo"] as? String
            
            
        })
        
        
    }
    
    @objc func imageTapped(_ sender: UITapGestureRecognizer) {
        let imageView = sender.view as! UIImageView
        let newImageView = UIImageView(image: imageView.image)
        

        newImageView.frame = UIScreen.main.bounds
        newImageView.backgroundColor = .black
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        newImageView.addGestureRecognizer(tap)
        self.view.addSubview(newImageView)
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true

    }
    
    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        sender.view?.removeFromSuperview()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
