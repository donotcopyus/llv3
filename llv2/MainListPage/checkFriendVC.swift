//
//  checkFriendVC.swift
//  llv2
//
//  Created by 林蔼欣 on 2018-09-20.
//  Copyright © 2018 Luna Cao. All rights reserved.
//

import UIKit
import Firebase

class checkFriendVC: UIViewController {

    @IBOutlet weak var headimage: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var senttime: UILabel!
    
    @IBOutlet weak var address: UILabel!
    
    @IBOutlet weak var image1: UIImageView!
    
    @IBOutlet weak var infor: UILabel!
    
    @IBOutlet weak var pidLabel: UILabel!
    @IBOutlet weak var uidLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!

    
    var pid = String()
    var uid = String()
    
    @IBAction func chat(_ sender: Any) {
        
        let viewController = storyboard?.instantiateViewController(withIdentifier: "chatLog") as! ChatLogController
        
        viewController.uid = uid
        viewController.username = self.username.text!
        viewController.url = self.urlLabel.text!
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func deletePost(_ sender: Any) {
        
        let postRef = Database.database().reference().child("friend/\(pid)")
        
        let alert = UIAlertController(title: "删除广告", message: "确定删除广告吗？", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (action: UIAlertAction!) in
            postRef.removeValue()
            
            let likedRef = Database.database().reference().child("users/collection/friend/")
            likedRef.observeSingleEvent(of: .value, with: {
                snapshot in
                
                for child in snapshot.children{
                    if let childSnapshot = child as? DataSnapshot,
                        let dict = childSnapshot.value as? [String:Any],
                        let thispid = dict["pid"] as? String{
                        
                        if (thispid == self.pid){
                            let userLikeRef = Database.database().reference().child("users/collection/friend/\(childSnapshot.key)")
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
  
    
    @IBOutlet weak var delete: UIButton!
    
    @IBOutlet weak var chat: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headimage.layer.cornerRadius = headimage.frame.height / 2.0
        headimage.layer.masksToBounds = true
        
        
        let pictureTap1 = UITapGestureRecognizer(target: self, action: #selector(checkXianzhiController.imageTappedIndex))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "举报", style: .plain, target: self, action: #selector(reportUser))
        
        //get pid，藏起来
        self.pidLabel.isHidden = true
        self.pidLabel.text = pid
        self.uidLabel.isHidden = true
        self.uidLabel.text = uid
        self.urlLabel.isHidden = true

        //如果是自己，没办法chat
        if (uidLabel.text == Auth.auth().currentUser!.uid){
            self.chat.isHidden = true
        }
        else{
            
            self.delete.isHidden = true
        }
        
        let postRef = Database.database().reference().child("friend/\(pid)")
        let image = UIImage(named:"default_profile_icon")
        
        postRef.observe(DataEventType.value, with:{
            (snapshot) in
            if let post = snapshot.value as? [String:Any]{
                let author = post["author"] as? [String:Any]
                
                let url = author!["photoURL"] as? String
                
                if(url == "default"){
                    self.urlLabel.text = "default"
                    self.headimage.image = #imageLiteral(resourceName: "icon.jpg")
                }
                else{
                    let tourl = URL(string:url!)
                    self.headimage.kf.indicatorType = .activity
                    self.headimage.kf.setImage(with: tourl, placeholder:image)
                    self.urlLabel.text = url
                }
                
                self.username.text = author!["username"] as? String
                
                let timeInterval = (post["timestamp"] as? Double)! / 1000
                let date = NSDate(timeIntervalSince1970: timeInterval)
                let dform = DateFormatter()
                dform.dateFormat = "MM月dd日 HH:mm"
                
                self.senttime.text = "发送于：" + dform.string(from:date as Date)
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.seconds(1), execute: {
                    let url1 = post["imageUrl"] as? String
                    if (url1 != ""){
                        let tourl1 = URL(string:url1!)
                        self.image1.kf.indicatorType = .activity
                        self.image1.kf.setImage(with: tourl1)
                        
                        self.image1.addGestureRecognizer(pictureTap1)
                        self.image1.isUserInteractionEnabled = true
                    }
                    
                    
                })
                
                
                self.address.text = "地址： " + (post["address"] as? String)!
                self.infor.text = post["info"] as? String
                
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
