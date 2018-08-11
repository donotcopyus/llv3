
//
//  profileCheckController.swift
//  llv2
//
//  Created by Luna Cao on 2018/8/8.
//  Copyright © 2018年 Luna Cao. All rights reserved.
//

import UIKit
import Firebase

class profileCheckController: UIViewController {
    
    
    @IBAction func back(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var pidLabel: UILabel!
    @IBOutlet weak var headImage: UIImageView!
    
    @IBOutlet weak var username: UILabel!
    
    @IBOutlet weak var time: UILabel!
    
    @IBOutlet weak var specific: UILabel!
    
    @IBOutlet weak var isCur: UILabel!
    
    @IBOutlet weak var extra: UILabel!
    
    @IBOutlet weak var uidLabel: UILabel!
    
    @IBOutlet weak var chat: UIButton!
    
    @IBOutlet weak var edit: UIButton!
    @IBOutlet weak var delete: UIButton!
    
    
    var pid = String()
    var uid = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        
        let postRef = Database.database().reference().child("exchange/\(pid)")
        
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
            
            self.time.text = dform.string(from:date as Date)
            
            let chu = post!["haveMoney"] as? String
            let qiu = post!["wantMoney"] as? String
            let fullstring = "出" + chu! + ", 求" + qiu!
            
            self.specific.text = fullstring
            
            let isC = post!["currencyBol"] as? Bool
            if (isC == true){
                self.isCur.text = "实时汇率"
            }
            else{
                self.isCur.text = "非实时汇率"
            }
            
            let extraI = post!["extraInfo"] as? String
            self.extra.text = extraI
            
        })
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func chat(_ sender: UIButton) {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "chatLog") as! ChatLogController
        
        viewController.uid = uid
        viewController.username = self.username.text!
      self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
