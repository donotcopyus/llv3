//
//  chat.swift
//  llv2
//
//  Created by Luna Cao on 2018/8/10.
//  Copyright © 2018年 Luna Cao. All rights reserved.
//

import UIKit
import Firebase

class ChatLogController: UICollectionViewController{
    
    //暂时放下的功能：具体广告显示
    
    var username = String()
    var uid = String()


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
        
        
//        let sendButton = UIButton(type: .system)
//        sendButton.setTitle("发送", for: .normal)
//        sendButton.translatesAutoresizingMaskIntoConstraints = false
//        containerView.addSubview(sendButton)
//        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
//        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
//        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
//        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
//
//        let inputTextField = UITextField()
//        inputTextField.placeholder = "今天bb点啥..."
//        inputTextField.translatesAutoresizingMaskIntoConstraints = false
//        containerView.addSubview(inputTextField)
//        inputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
//        inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
//        inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
//        inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
//
//        let separatorLineView = UIView()
//        separatorLineView.backgroundColor = UIColor.black
//        separatorLineView.addSubview(separatorLineView)
//
//        separatorLineView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
//        separatorLineView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
//        separatorLineView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
//        separatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        
        
        
    }
    
}
