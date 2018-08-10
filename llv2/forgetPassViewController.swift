//
//  forgetPassViewController.swift
//  llv2
//
//  Created by Luna Cao on 2018/7/26.
//  Copyright © 2018年 Luna Cao. All rights reserved.
//

import UIKit
import Firebase

class forgetPassViewController: UIViewController {
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var message: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    @IBAction func clickYes(_ sender: UIButton) {
        
        guard let emailF = email.text else {
            //alert请输入邮箱
            return
        }
        
        Auth.auth().sendPasswordReset(withEmail:emailF){
            (error) in
            
            if (error != nil){
                //alert
                self.message.text = "此邮箱账号不存在"
            }
            else{
                //alert
                self.message.text = "一封重设密码的邮件已发送，请查收"
                self.performSegue(withIdentifier: "backToLogin", sender: self)
            }
            
        }
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }


}
