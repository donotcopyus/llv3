//
//  checkXianzhiController.swift
//  llv2
//
//  Created by Luna Cao on 2018/8/10.
//  Copyright © 2018年 Luna Cao. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher


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
    @IBOutlet weak var delete: UIButton!
    
    @IBOutlet weak var imageurl: UILabel!
    
    var pid = String()
    var uid = String()
    var photoArray = [Image]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headImage.layer.cornerRadius = headImage.frame.height / 2.0
        headImage.layer.masksToBounds = true
        
                navigationItem.rightBarButtonItem = UIBarButtonItem(title: "举报", style: .plain, target: self, action: #selector(reportUser))
        
        let pictureTap1 = UITapGestureRecognizer(target: self, action: #selector(checkXianzhiController.imageTappedIndex))
        let pictureTap2 = UITapGestureRecognizer(target: self, action: #selector(checkXianzhiController.imageTappedIndex))
        let pictureTap3 = UITapGestureRecognizer(target: self, action: #selector(checkXianzhiController.imageTappedIndex))

        
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
        
         let postRef = Database.database().reference().child("xianzhi/\(pid)")
         let image = UIImage(named:"default_profile_icon")

        
        postRef.observe(DataEventType.value, with:{
            (snapshot) in
            if let post = snapshot.value as? [String:Any]{
                let author = post["author"] as? [String:Any]
            
            let url = author!["photoURL"] as? String
                
                if(url == "default"){
                    self.imageurl.text = "default"
                    self.headImage.image = #imageLiteral(resourceName: "icon.jpg")
                }
            
        else{
            let tourl = URL(string:url!)

            self.headImage.kf.indicatorType = .activity
            self.headImage.kf.setImage(with: tourl, placeholder:image)
            self.imageurl.text = url
                }

            
            self.username.text = author!["username"] as? String
            
            let timeInterval = (post["timestamp"] as? Double)! / 1000
            let date = NSDate(timeIntervalSince1970: timeInterval)
            let dform = DateFormatter()
            dform.dateFormat = "MM月dd日 HH:mm"
            
            self.time.text = "发送于：" + dform.string(from:date as Date)
            
       DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.seconds(1), execute: {
                let url1 = post["imageOneUrl"] as? String
            if (url1 != ""){
            let tourl1 = URL(string:url1!)
                self.image1.kf.indicatorType = .activity
                self.image1.kf.setImage(with: tourl1)

                self.image1.addGestureRecognizer(pictureTap1)
                self.image1.isUserInteractionEnabled = true
            }

                let url2 = post["imageTwoUrl"] as? String
            if (url2 != ""){
                let tourl2 = URL(string:url2!)
                self.image2.kf.indicatorType = .activity
                self.image2.kf.setImage(with: tourl2)

                self.image2.addGestureRecognizer(pictureTap2)
                self.image2.isUserInteractionEnabled = true
            }

                let url3 = post["imageThreeUrl"] as? String
            if (url3 != ""){
                let tourl3 = URL(string:url3!)
                self.image3.kf.indicatorType = .activity
                self.image3.kf.setImage(with: tourl3)

                self.image3.addGestureRecognizer(pictureTap3)
                self.image3.isUserInteractionEnabled = true
            }

        })
        
            
                self.name.text = "物品： " + (post["name"] as? String)!
                self.price.text = "价格： " + (post["price"] as? String)!
            
                self.info.text = post["extraInfo"] as? String
            
            }
        })
        
        
    }
    
    @objc func reportUser(){
        
        let alert = UIAlertController(title: "举报原因", message: "请选择举报原因", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "广告骚扰", style: .default , handler:{ (UIAlertAction)in
            let reportUID = self.uidLabel.text
            
            let repRef = Database.database().reference().child("report").childByAutoId()
            
            let repObj = [
                "uid":reportUID!,
                "reason":"广告骚扰"
                ] as [String:Any]
            
            repRef.setValue(repObj, withCompletionBlock:{
                error, ref in
                if error == nil{
                    
                    let ok = UIAlertController(title: "举报成功", message: "感谢您的举报，我们会在24小时内处理", preferredStyle: .alert)
                    
                    self.present(ok, animated: true, completion: nil)
                    
                    let when = DispatchTime.now() + 2
                    DispatchQueue.main.asyncAfter(deadline: when){
                        // your code with delay
                        ok.dismiss(animated: true, completion: nil)
                        return
                    }
                }else{
                    
                }
            })
            
        }))
        
        alert.addAction(UIAlertAction(title: "色情低俗", style: .default , handler:{ (UIAlertAction)in
            
            let reportUID = self.uidLabel.text
            
            let repRef = Database.database().reference().child("report").childByAutoId()
            
            let repObj = [
                "uid":reportUID!,
                "reason":"色情低俗"
                ] as [String:Any]
            
            repRef.setValue(repObj, withCompletionBlock:{
                error, ref in
                if error == nil{
                    
                    let ok = UIAlertController(title: "举报成功", message: "感谢您的举报，我们会在24小时内处理", preferredStyle: .alert)
                    
                    self.present(ok, animated: true, completion: nil)
                    
                    let when = DispatchTime.now() + 2
                    DispatchQueue.main.asyncAfter(deadline: when){
                        // your code with delay
                        ok.dismiss(animated: true, completion: nil)
                        return
                    }
                }else{
                    
                }
            })
            
        }))
        
        alert.addAction(UIAlertAction(title: "钱财诈骗", style: .default , handler:{ (UIAlertAction)in
            
            let reportUID = self.uidLabel.text
            
            let repRef = Database.database().reference().child("report").childByAutoId()
            
            let repObj = [
                "uid":reportUID!,
                "reason":"钱财诈骗"
                ] as [String:Any]
            
            repRef.setValue(repObj, withCompletionBlock:{
                error, ref in
                if error == nil{
                    
                    let ok = UIAlertController(title: "举报成功", message: "感谢您的举报，我们会在24小时内处理", preferredStyle: .alert)
                    
                    self.present(ok, animated: true, completion: nil)
                    
                    let when = DispatchTime.now() + 2
                    DispatchQueue.main.asyncAfter(deadline: when){
                        // your code with delay
                        ok.dismiss(animated: true, completion: nil)
                        return
                    }
                }else{
                    
                }
            })
            
        }))
        
        alert.addAction(UIAlertAction(title: "违反法律", style: .default, handler:{ (UIAlertAction)in
            
            let reportUID = self.uidLabel.text
            
            let repRef = Database.database().reference().child("report").childByAutoId()
            
            let repObj = [
                "uid":reportUID!,
                "reason":"违反法律"
                ] as [String:Any]
            
            repRef.setValue(repObj, withCompletionBlock:{
                error, ref in
                if error == nil{
                    
                    let ok = UIAlertController(title: "举报成功", message: "感谢您的举报，我们会在24小时内处理", preferredStyle: .alert)
                    
                    self.present(ok, animated: true, completion: nil)
                    
                    let when = DispatchTime.now() + 2
                    DispatchQueue.main.asyncAfter(deadline: when){
                        // your code with delay
                        ok.dismiss(animated: true, completion: nil)
                        return
                    }
                }else{
                    
                }
            })
            
        }))
        
        alert.addAction(UIAlertAction(title: "屏蔽此人", style: .default, handler:{ (UIAlertAction)in
            
            
            let ok = UIAlertController(title: "屏蔽成功", message: "您将不再收到此人的消息！", preferredStyle: .alert)
            
            self.present(ok, animated: true, completion: nil)
            
            let when = DispatchTime.now() + 2
            DispatchQueue.main.asyncAfter(deadline: when){
                // your code with delay
                ok.dismiss(animated: true, completion: nil)
                return
            }
            
        }))
        
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler:{ (UIAlertAction)in
            return
        }))
        
        self.present(alert, animated: true, completion: {
        })
        
        
    }
    
    @objc func imageTappedIndex(_ sender: UITapGestureRecognizer) {
        let imageView = sender.view as! UIImageView
        let newImageView = UIImageView(image: imageView.image)

        newImageView.frame = UIScreen.main.bounds
        newImageView.backgroundColor = .black
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        newImageView.addGestureRecognizer(tap)
        
        //加左拉右拉的gesture，触发，同时里面需要连接dismiss
        
        self.view.addSubview(newImageView)
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true

    }


    
    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        sender.view?.removeFromSuperview()
    }

    
    @IBAction func chat(_ sender: UIButton) {
        
            let viewController = storyboard?.instantiateViewController(withIdentifier: "chatLog") as! ChatLogController
            
            viewController.uid = uid
            viewController.username = self.username.text!
            viewController.url = self.imageurl.text!
            self.navigationController?.pushViewController(viewController, animated: true)

    }
    
    
    @IBAction func deletepost(_ sender: UIButton) {
        
        let postRef = Database.database().reference().child("xianzhi/\(pid)")
        
        let alert = UIAlertController(title: "删除广告", message: "确定删除广告吗？", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (action: UIAlertAction!) in
            postRef.removeValue()
            
            let likedRef = Database.database().reference().child("users/collection/xianzhi/")
            
            likedRef.observeSingleEvent(of: .value, with: {
                snapshot in
                
                for child in snapshot.children{
                    if let childSnapshot = child as? DataSnapshot,
                        let dict = childSnapshot.value as? [String:Any],
                        let thispid = dict["pid"] as? String{
                        
                        if (thispid == self.pid){
                            let userLikeRef = Database.database().reference().child("users/collection/xianzhi/\(childSnapshot.key)")
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
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func share(_ sender: UIButton) {
        let textToShare = "我在使用一个非常好用的在加华人app，一键发布carpool/闲置/换汇/交友广告，特别酷，你也来试试吧: "
        if let myWebsite = URL(string: "http://itunes.apple.com/app/id1436232989") {//Enter link to your app here
            let objectsToShare = [textToShare, myWebsite] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            //Excluded Activities
            //activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList]
            
            
            activityVC.popoverPresentationController?.sourceView = sender
            
            self.present(activityVC, animated: true, completion: nil)
        }
    }


}



