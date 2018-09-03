//
//  exchangeVC.swift
//  llv2
//
//  Created by 林蔼欣 on 2018-07-26.
//  Copyright © 2018 Luna Cao. All rights reserved.
//

import UIKit
import Firebase

class exchangeVC: UIViewController {

    
    var button = dropDownBtn()
    var b2 = dropDownBtn()
    var currency = false
    
    @IBOutlet weak var wait: UIActivityIndicatorView!
    
    
    @IBOutlet weak var extraInfo: UITextField!

    @IBOutlet weak var btnCheckBox: UIButton!
    
    @IBAction func checkMarkTapped(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveLinear, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        }) { (success) in
            UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveLinear, animations: {
                sender.isSelected = !sender.isSelected
                sender.transform = .identity
                
            }, completion: nil)
        }
        
        if (currency == false){
            currency = true
        }
        else if (currency == true){
            currency = false
        }

    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        wait.isHidden = true
        btnCheckBox.setImage(UIImage(named:"Checkmarkempty"), for: .normal)
        btnCheckBox.setImage(UIImage(named:"Checkmark"), for: .selected)
        
        
        button = dropDownBtn.init(frame: CGRect(x:30, y:155, width: 150, height: 40))
        
        button.setTitle("求币种", for: .normal)
        
        button.translatesAutoresizingMaskIntoConstraints = true
        
        self.view.addSubview(button)
        
    
        button.dropView.dropDownOptions = ["RMB","加币","美金","港币","日元","英镑"]
        
        //---------------------------------
        b2 = dropDownBtn.init(frame: CGRect(x:210, y:155, width: 150, height: 40))
        
        b2.setTitle("出币种", for: .normal)
        
        b2.translatesAutoresizingMaskIntoConstraints = true
        
        b2.dropView.dropDownOptions = ["RMB","加币","美金","港币","日元","英镑"]
        
        self.view.addSubview(b2)
 
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        
        view.addGestureRecognizer(rightSwipe)
        
    }
    
    @objc func handleSwipe(_ sender:UISwipeGestureRecognizer) {
        performSegue(withIdentifier: "goRight", sender: self)
        
    }
   
    //数据库行为

    @IBAction func sendRequest(_ sender: Any) {
        
        
        let want = button.currentTitle!
        let have = b2.currentTitle!
        
        if (want == "求币种" || have == "出币种"){
            //alert
            let alert = UIAlertController(title: title, message: "出币种或求币种为空", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
               
            } ))
            
            present(alert, animated: true, completion: nil)
            return

        }
        if(want == have){
            let alert = UIAlertController(title: title, message: "出币种与求币种相同", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            } ))
            
            present(alert, animated: true, completion: nil)
                            return
        }
        
        let alert = UIAlertController(title: "上传", message: "请等待...", preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame:alert.view.bounds)
        loadingIndicator.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        
        alert.view.addSubview(loadingIndicator)
        loadingIndicator.isUserInteractionEnabled = false
        loadingIndicator.startAnimating()
        
        self.present(alert, animated: true, completion: nil)
   
        
        let extraIn = self.extraInfo.text!
        let isCurrency = currency
        
        guard let userProfile = UserService.currentUserProfile
            else{
                return
        }
        
        let postRef = Database.database().reference().child("exchange").childByAutoId()
        
        let postObj = [
            
            "wantMoney":want,
            "haveMoney":have,
            "extraInfo":extraIn,
            "currencyBol":isCurrency,
            "timestamp":[".sv":"timestamp"],
            "author":[
                "uid":userProfile.uid,
                "username":userProfile.username,
                "photoURL":userProfile.photoURL.absoluteString
            ]
            
            ] as [String:Any]
        
        postRef.setValue(postObj,withCompletionBlock:{
            error, ref in
            
            if error == nil{
                
                self.performSegue(withIdentifier: "eB", sender: self)

            }
                
            else{
                //alert, error
                let alert = UIAlertController(title: self.title, message: "出错", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    return
                } ))
                self.present(alert,animated:true, completion:nil)
               return
            }
            
        })
    }
    
   
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //lauren————————————————————————————————————————————————————————————
    //button to go back to main
    @IBOutlet weak var back: UIButton!


}

