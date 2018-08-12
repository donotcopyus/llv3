//
//  chat.swift
//  llv2
//
//  Created by Luna Cao on 2018/8/10.
//  Copyright © 2018年 Luna Cao. All rights reserved.
//

import UIKit
import Firebase

class ChatLogController: UICollectionViewController,UITextFieldDelegate{
    
    //暂时放下的功能：具体广告显示
    
    var username = String()
    var uid = String()

    
    lazy var inputTextField:UITextField={
    let textField = UITextField()
    textField.placeholder = "今天bb点啥..."
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.delegate = self
    return textField
    }()


    @IBAction func back(_ sender: UIButton) {
               self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
       super.viewDidLoad()

      self.navigationItem.title = username

      setupInputComponents()
        
    }
    
    
    func setupInputComponents(){
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(containerView)
        
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("发送", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        containerView.addSubview(sendButton)
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true


        containerView.addSubview(inputTextField)
        
        inputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true

        let separatorLineView = UIView()
        //分割线颜色
        separatorLineView.backgroundColor = UIColor.gray
        separatorLineView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(separatorLineView)

        separatorLineView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        separatorLineView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        separatorLineView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        separatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true

    }
    
    //handle send
    @objc func handleSend(){
        
        let messageRef = Database.database().reference().child("messages").childByAutoId()
        
        let databaseRef = Database.database().reference().child("users/profile/\(self.uid)")
        
        databaseRef.observe(.value, with: { (snapshot) in
            
            let dict = snapshot.value as? [String:Any]
            let tourl = dict!["photoURL"] as? String
            
            let values = ["text": self.inputTextField.text!,
                          "toId": self.uid,
                          "fromId": Auth.auth().currentUser!.uid,
                          "timestamp": [".sv":"timestamp"],
                          "toUname":self.username,
                          "toUrl":tourl!
                ] as [String : Any]
            
            messageRef.setValue(values,withCompletionBlock:
                {
                    error, ref in
                    if error == nil{
                        //发送成功
                    }
                    else{
                        //发送错误,alert
                    }
            })
        })

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        return true
    }
    
}
