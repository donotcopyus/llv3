//
//  loginController.swift
//  LunaLauren
//
//  Created by Luna Cao on 2018/7/11.
//  Copyright © 2018年 Luna Cao. All rights reserved.
//

import UIKit
import Firebase
import RevealingSplashView


class loginController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var passField: UITextField!
    
    @IBOutlet weak var labelText: UILabel!
    
    
    @IBAction func handleSignin(_ sender: UIButton) {
        
        guard let email = emailField.text else{
            return
        }
        
        guard let pass = passField.text else{
            return
        }
        
        Auth.auth().signIn(withEmail: email, password:pass){
            user, error in
            if error == nil && user != nil{
                self.performSegue(withIdentifier: "loggedin", sender: self)
            }
            else{
                let alert = UIAlertController(title: self.title, message: "登录失败，用户名或密码错误", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                    alert.dismiss(animated: true, completion: nil)
                } ))
                
                self.present(alert, animated: true, completion: nil)
                
                return
            }
        }
    }
    
    
    
    @IBAction func forgetPass(_ sender: UIButton) {

    }
    
    
    @IBOutlet weak var logo: UIImageView!
    
    override func viewDidLoad() {

      super.viewDidLoad()
        
        if UIDevice.current.userInterfaceIdiom == .pad{
            logo.isHidden = true
        }
        
        Auth.auth().addStateDidChangeListener {auth, user in
            if user != nil{
                self.performSegue(withIdentifier: "loggedin", sender: self)
            }
            else{
                //user not log in
            }
            
        }
        setupViews()

        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }

    func setupViews() {
        view.addSubview(revealingSplashView)
        
        revealingSplashView.startAnimation()
    }
    
    
    
    let revealingSplashView = RevealingSplashView(iconImage: #imageLiteral(resourceName: "harkore"), iconInitialSize: CGSize(width: 123, height: 123), backgroundColor: UIColor.white)
    
 



    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  

}
