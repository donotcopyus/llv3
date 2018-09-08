//
//  personalVC.swift
//  llv2
//
//  Created by 林蔼欣 on 2018-08-04.
//  Copyright © 2018 Luna Cao. All rights reserved.
//

import UIKit
import Firebase

class personalVC: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!


    @IBOutlet weak var labelText: UILabel!
    
   
    @IBAction func nicknameChange(_ sender: UIButton) {
        
        let oldname = Auth.auth().currentUser?.displayName
        
        let alert = UIAlertController(title: self.title, message: "请输入想要修改的昵称", preferredStyle: .alert)
        alert.addTextField(configurationHandler: {textField in
            textField.placeholder = "输入昵称"
        })
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (action) in
            
            let newname = alert.textFields![0].text!
            if (newname == ""){
                let newAlert = UIAlertController(title:"错误", message:"请输入新的昵称", preferredStyle:.alert)
                newAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                    return
                } ))
                self.present(newAlert, animated: true, completion: nil)
            }
            
            var length = 0
            for char in newname{
                length += "\(char)".lengthOfBytes(using: String.Encoding.utf8) == 3 ? 2: 1
            }
            
            if(length > 18){
                let lengthalert = UIAlertController(title: self.title, message: "用户名过长", preferredStyle: .alert)
                lengthalert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                    alert.dismiss(animated: true, completion: nil)
                } ))
                self.present(lengthalert, animated: true, completion: nil)
                return
            }
            
            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
            changeRequest?.displayName = newname
            changeRequest?.commitChanges{
                error in
                if error == nil{
                    
                    guard let uid = Auth.auth().currentUser?.uid else{
                        return
                    }
                    let newObj = ["username":newname]
                    //修改数据库
                     let databaseRef = Database.database().reference().child("users/profile/\(uid)")
                    databaseRef.updateChildValues(newObj)
                    
                    let carpoolRef = Database.database().reference().child("carpool")
                    carpoolRef.observe(.value, with: {
                        snapshot in
                        for child in snapshot.children{
                            if let childSnapshot = child as? DataSnapshot,
                                let dict = childSnapshot.value as? [String:Any],
                                let thisAuthor = dict["author"] as? [String:Any],
                                let thisuid = thisAuthor["uid"] as? String
                            {if (thisuid == uid){
                                carpoolRef.child(childSnapshot.key).child("author").updateChildValues(newObj){
                                    error, ref in
                                    if error != nil{
                                        print("错误")
                                    }
                                }
                                }}}})
                    
                            let exchangeRef = Database.database().reference().child("exchange")
                    exchangeRef.observe(.value, with: {
                        snapshot in
                        for child in snapshot.children{
                            if let childSnapshot = child as? DataSnapshot,
                                let dict = childSnapshot.value as? [String:Any],
                                let thisAuthor = dict["author"] as? [String:Any],
                                let thisuid = thisAuthor["uid"] as? String
                            {if (thisuid == uid){
                        exchangeRef.child(childSnapshot.key).child("author").updateChildValues(newObj)
                                }}}})
                    
                      let xianzhiRef = Database.database().reference().child("xianzhi")
                    xianzhiRef.observe(.value, with: {
                        snapshot in
                        for child in snapshot.children{
                            if let childSnapshot = child as? DataSnapshot,
                                let dict = childSnapshot.value as? [String:Any],
                                let thisAuthor = dict["author"] as? [String:Any],
                                let thisuid = thisAuthor["uid"] as? String
                            {if (thisuid == uid){
                                xianzhiRef.child(childSnapshot.key).child("author").updateChildValues(newObj)
                                }}}})
                    
                    
                    let messageRef = Database.database().reference().child("messages")
                    let fromObj = ["fromUname":newname]
                    let toObj = ["toUname":newname]
                    
                    messageRef.observe(.value, with:{
                        snapshot in
                        
                        for child in snapshot.children{
                            if let childSnapshot = child as? DataSnapshot,
                            let dict = childSnapshot.value as? [String:Any],
                            let curFrom = dict["fromUname"] as? String,
                                let curTo = dict["toUname"] as? String{
                                if(curFrom == oldname){
               messageRef.child(childSnapshot.key).updateChildValues(fromObj)
                                }
                                if(curTo == oldname){
                                messageRef.child(childSnapshot.key).updateChildValues(toObj)
                                }
                            }
                        }
                    })
                    
                    
                    alert.dismiss(animated: true, completion: nil)
                }
                else{
                    let newAlert1 = UIAlertController(title:"错误", message:"修改昵称失败", preferredStyle:.alert)
                    newAlert1.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                        return
                    } ))
                    self.present(newAlert1, animated: true, completion: nil)
                }
            }
            
        } ))
        
        alert.addAction(UIAlertAction(title: "取消", style: .default, handler: { (action) in
            return
        } ))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func passwordChange(_ sender: UIButton) {
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.labelText.text = " 欢迎，" + (Auth.auth().currentUser?.displayName)!
        
        guard let uid = Auth.auth().currentUser?.uid else{
            return
        }
        
        //handle showing the profile image
        let databaseRef = Database.database().reference().child("users/profile/\(uid)")
        let refHandle = databaseRef.observe(DataEventType.value, with:{
            (snapshot) in
            let curUser = snapshot.value as? NSDictionary
            let urlString = curUser?["photoURL"] as? String ?? ""
            
            let url = URL(string:urlString)
            let data = try? Data(contentsOf:url!)
            self.profileImageView.image = UIImage(data:data!)

            
        })
        


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func handleLogout(_ sender: UIButton) {

        
        let alert = UIAlertController(title: self.title, message: "确定要登出吗？", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (action) in
                    try! Auth.auth().signOut()
                    self.performSegue(withIdentifier: "logoutSegue", sender: self)
        } ))
        
        alert.addAction(UIAlertAction(title: "取消", style: .default, handler: { (action) in
            return
        } ))
        
        self.present(alert, animated: true, completion: nil)
        

    }
}


//
