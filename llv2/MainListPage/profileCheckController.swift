//
//  profileCheckController.swift
//  llv2
//
//  Created by Luna Cao on 2018/8/8.
//  Copyright © 2018年 Luna Cao. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

class profileCheckController: UIViewController {
    

    
    @IBOutlet weak var pidLabel: UILabel!
    @IBOutlet weak var headImage: UIImageView!
    
    @IBOutlet weak var username: UILabel!
    
    @IBOutlet weak var time: UILabel!
    
    @IBOutlet weak var specific: UILabel!
    
    @IBOutlet weak var isCur: UILabel!
    
    @IBOutlet weak var extra: UILabel!
    
    @IBOutlet weak var uidLabel: UILabel!
    
    @IBOutlet weak var imageurl: UILabel!
    
    
    @IBOutlet weak var chat: UIButton!
    

    @IBOutlet weak var delete: UIButton!
    
    
    var pid = String()
    var uid = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "举报", style: .plain, target: self, action: #selector(reportUser))
        
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
        
    
       let postRef = Database.database().reference().child("exchange/\(pid)")
        
        postRef.observe(DataEventType.value, with:{
          (snapshot) in
            if let post = snapshot.value as? [String:Any]{
                let author = post["author"] as? [String:Any]
            
         DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.seconds(1), execute: {
            
            
            let url = author!["photoURL"] as? String
            
            if(url == "default"){
                self.imageurl.text = "default"
                self.headImage.image = #imageLiteral(resourceName: "icon.jpg")
            }
            else{
            self.imageurl.text = url
            let tourl = URL(string:url!)
             self.headImage.kf.indicatorType = .activity
            self.headImage.kf.setImage(with: tourl)
            }
             })
            
            self.username.text = author!["username"] as? String
            
                let timeInterval = (post["timestamp"] as? Double)! / 1000
            let date = NSDate(timeIntervalSince1970: timeInterval)
            let dform = DateFormatter()
            dform.dateFormat = "MM月dd日 HH:mm"
            
            self.time.text = dform.string(from:date as Date)
            
                let chu = post["haveMoney"] as? String
                let qiu = post["wantMoney"] as? String
            let fullstring = "出" + chu! + ", 求" + qiu!
            
            self.specific.text = fullstring
            
                let isC = post["currencyBol"] as? Bool
            if (isC == true){
                self.isCur.text = "实时汇率"
            }
            else{
                self.isCur.text = "非实时汇率"
            }
            
                let extraI = post["extraInfo"] as? String
                self.extra.text = extraI}
            
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
    
    
    @IBAction func chat(_ sender: UIButton) {


        let viewController = storyboard?.instantiateViewController(withIdentifier: "chatLog") as! ChatLogController
        
        viewController.uid = uid
        viewController.username = self.username.text!
        viewController.url = self.imageurl.text!

        self.navigationController?.pushViewController(viewController, animated: true)

    }
    
    
    @IBAction func deletePost(_ sender: UIButton) {
        
        let postRef = Database.database().reference().child("exchange/\(pid)")
        
        let alert = UIAlertController(title: "删除广告", message: "确定删除广告吗？", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (action: UIAlertAction!) in
           postRef.removeValue()
            
         let likedRef = Database.database().reference().child("users/collection/exchange/")
            
            likedRef.observeSingleEvent(of: .value, with: {
                snapshot in
                
                for child in snapshot.children{
                    if let childSnapshot = child as? DataSnapshot,
                    let dict = childSnapshot.value as? [String:Any],
                        let thispid = dict["pid"] as? String{
                        
                        if (thispid == self.pid){
                            let userLikeRef = Database.database().reference().child("users/collection/exchange/\(childSnapshot.key)")
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
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
