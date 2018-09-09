//
//  changePassVC.swift
//  llv2
//
//  Created by Luna Cao on 2018/9/9.
//  Copyright © 2018年 Luna Cao. All rights reserved.
//

import UIKit
import Firebase

class changePassVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet var oldpass: UITextField!
    @IBOutlet var newpass: UITextField!
    @IBOutlet var renewpass: UITextField!
    
    
    @IBAction func change(sender: UIButton) {
        
        if (oldpass.text == "" || newpass.text == ""){
            
            let empty = UIAlertController(title:"错误", message:"请填写密码", preferredStyle:.alert)
            empty.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in

            } ))
            self.present(empty, animated: true, completion: nil)
                            return
        }
        
        if (newpass.text != renewpass.text){
            
            let error = UIAlertController(title:"错误", message:"请确保新密码与重新输入的新密码一致", preferredStyle:.alert)
            error.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                
            } ))
            self.present(error, animated: true, completion: nil)
            return
        }
        
        let cre:AuthCredential = EmailAuthProvider.credential(withEmail: (Auth.auth().currentUser?.email)!, password: oldpass.text!)
        
        Auth.auth().currentUser?.reauthenticateAndRetrieveData(with: cre, completion: { (authResult, error) in
            
            if error != nil{
                let newAlert = UIAlertController(title:"错误", message:"用户身份验证错误", preferredStyle:.alert)
                newAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                    
                } ))
                self.present(newAlert, animated: true, completion: nil)
                return
            }
            else{
                Auth.auth().currentUser?.updatePassword(to: self.newpass.text!)
                let suc = UIAlertController(title:"成功", message:"修改密码成功！", preferredStyle:.alert)
                suc.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                    self.dismiss(animated: true, completion: nil)
                } ))
                self.present(suc, animated: true, completion: nil)
            }
            
        })
        
     
        

        
        
    }
    

}
