//
//  chat.swift
//  llv2
//
//  Created by Luna Cao on 2018/8/10.
//  Copyright © 2018年 Luna Cao. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher


class ChatLogController: UICollectionViewController,UITextFieldDelegate,UICollectionViewDelegateFlowLayout{
    
    //暂时放下的功能：具体广告显示
    
    var username = String()
    var uid = String()
    var url = String()

    var messages = [Message]()
    
    
    lazy var inputTextField:UITextField={
    let textField = UITextField()
    textField.placeholder = "发送消息内容..."
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.delegate = self
    return textField
    }()



    @IBAction func back(_ sender: UIButton) {
               self.dismiss(animated: true, completion: nil)
    }
    
        var containerViewBottomAnchor: NSLayoutConstraint?
    
    func observeMessages(){
        guard let thisUid = Auth.auth().currentUser?.uid else{
            return}
        let thatUid = self.uid
        
        let message = Database.database().reference().child("messages")

        message.observe(.childAdded, with: { (snapshot) in
            
            if let dict = snapshot.value as? [String:AnyObject]{
                let mes = Message()
                mes.text = dict["text"] as? String
                mes.fromId = dict["fromId"] as? String
                mes.timestamp = dict["timestamp"] as? Double
                mes.toId = dict["toId"] as? String
                mes.toUname = dict["toUname"] as? String
                mes.fromUname = dict["fromUname"] as? String
                mes.toUrl = dict["toUrl"] as? String
                mes.fromUrl = dict["fromUrl"] as? String
                
                //消息来自
                 if ((mes.toId == thisUid && mes.fromId == thatUid) || (mes.toId == thatUid && mes.fromId == thisUid) ){
                    self.messages.append(mes)

                    DispatchQueue.main.async {
                        self.collectionView?.reloadData()
                        //auto scroll to the end
                        self.collectionView?.scrollToItem(at: NSIndexPath(row: self.messages.count - 1, section: 0) as IndexPath, at: .bottom, animated: false)
                    }}}}, withCancel: nil)}
    
    
    
    override func viewDidLoad() {
       super.viewDidLoad()

      self.navigationItem.title = username
        
        observeMessages()
        
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)

        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(CollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.alwaysBounceVertical = true
        
        collectionView?.keyboardDismissMode = .interactive
        
   
    }
    
    

    
    lazy var inputContainerView:UIView = {
        let containerView = UIView()
        containerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
        containerView.backgroundColor = UIColor.white

        let sendButton = UIButton(type: .system)
        sendButton.setTitle("发送", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        containerView.addSubview(sendButton)
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true


        containerView.addSubview(self.inputTextField)

        self.inputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        self.inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        self.inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        self.inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true

        let separatorLineView = UIView()
        //分割线颜色
        separatorLineView.backgroundColor = UIColor.gray
        separatorLineView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(separatorLineView)

        separatorLineView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        separatorLineView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        separatorLineView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        separatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return containerView
    }()
    
    
    override var inputAccessoryView: UIView?{
        get{
        return inputContainerView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }

    
    func setupKeyboardObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: Notification.Name.UIKeyboardWillShow, object: nil)
       NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func handleKeyboardWillShow(notification: Notification){
        let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardDuration = notification.userInfo?[UIKeyboardAnimationCurveUserInfoKey] as! Double
        containerViewBottomAnchor?.constant = -keyboardFrame.height
        UIView.animate(withDuration: keyboardDuration){
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func handleKeyboardWillHide(notification: Notification){
        let keyboardDuration = notification.userInfo?[UIKeyboardAnimationCurveUserInfoKey] as! Double
        containerViewBottomAnchor?.constant = 0
        UIView.animate(withDuration: keyboardDuration){
            self.view.layoutIfNeeded()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    let cellId = "cellId"
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CollectionViewCell
        
        let message = messages[indexPath.item]
        cell.textView.text = message.text
        
        setUpCell(cell: cell, message: message)
        
        cell.bubbleWidthAnchor?.constant = estimateFrameForText(text: message.text!).width + 32
        
        return cell
    }
    
    private func setUpCell(cell: CollectionViewCell, message:Message){
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.seconds(1), execute: {
        let url = message.fromUrl
            
            if url == "default"{
                cell.profileImageView.image = #imageLiteral(resourceName: "icon.jpg")
            }
            else{
        let tourl = URL(string:url!)
        cell.profileImageView.kf.indicatorType = .activity
                cell.profileImageView.kf.setImage(with: tourl)}}
        )
        
        if message.fromId == Auth.auth().currentUser?.uid{
            //outgoing blackblue
            cell.bubbleView.backgroundColor = UIColor.black
            cell.profileImageView.isHidden = true
            cell.bubbleViewRightAnchor?.isActive = true
            cell.bubbleViewLeftAnchor?.isActive = false
        }
        else{
            //ingoing gray
            cell.bubbleView.backgroundColor = UIColor(red: 0.49, green: 0.69, blue: 49, alpha: 1.0)
            cell.profileImageView.isHidden = false
            cell.bubbleViewRightAnchor?.isActive = false
            cell.bubbleViewLeftAnchor?.isActive = true
        }
    }
    
    //size per cell
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height:CGFloat = 80
        
        //get estimated height somehow??
        if let text = messages[indexPath.item].text {
            height = estimateFrameForText(text: text).height + 20
        }
        
        return CGSize(width: view.frame.width, height: height)
        
    }
    
    private func estimateFrameForText(text:String) -> CGRect{
        let size = CGSize(width:200, height:1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string:text).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 16)], context: nil)
    }
    
    
    func setupInputComponents(){

   

    }
    
    
    
    
    //handle send
    @objc func handleSend(){
        
        if self.inputTextField.text! == ""{
            //alert,发送信息不能为空！
            return
        }
        
        let messageRef = Database.database().reference().child("messages").childByAutoId()

        let databaseRef = Database.database().reference().child("users/profile/\(Auth.auth().currentUser!.uid)")
        
        
        databaseRef.observe(.value, with: { (snapshot) in
            
            let dict = snapshot.value as? [String:Any]
            let tourl = dict!["photoURL"] as? String

            let values = ["text": self.inputTextField.text!,
                          "toId": self.uid,
                          "fromId": Auth.auth().currentUser!.uid,
                          "timestamp": [".sv":"timestamp"],
                          "toUname":self.username,
                          "fromUname":Auth.auth().currentUser!.displayName!,
                          "fromUrl":tourl!,
                          "toUrl":self.url
                ] as [String : Any]
                messageRef.setValue(values,withCompletionBlock:
                    {
                        error, ref in
                        if error == nil{
                            //发送成功
                         self.inputTextField.text = nil
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
