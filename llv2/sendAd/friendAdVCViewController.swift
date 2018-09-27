//
//  friendAdVCViewController.swift
//  llv2
//
//  Created by 林蔼欣 on 2018-09-18.
//  Copyright © 2018 Luna Cao. All rights reserved.
//

import UIKit
import Firebase

class friendAdVCViewController: UIViewController{
    
    var imagepicker: UIImagePickerController!
    
    
    //发送btn
    @IBAction func send(_ sender: Any) {
        
        let extrainfo = self.infor.text
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy-MM-dd"
        let date = dateFormatter.string(from: datepicker.date)
        
        //确保出发日期比目前日期要晚
        let currentDate = Date()
        let compare = NSCalendar.current.compare(currentDate, to: datepicker.date, toGranularity: .day)
        
        if (compare == ComparisonResult.orderedDescending) {
            //alert
            let alert = UIAlertController(title: title, message: "出发日期或时间已过！", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            } ))
            
            present(alert, animated: true, completion: nil)
            return
        }
        
         let address = self.text.text
        
         if address == "活动地址"{
            let alert = UIAlertController(title: title, message: "请输入地址", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            } ))
            
            present(alert, animated: true, completion: nil)
            return
        }
        
        
        guard let userProfile = UserService.currentUserProfile else{
            return}
        
        
        let postRef = Database.database().reference().child("friend").childByAutoId()
        
        let postObj = [
            
            "info": extrainfo ?? "他什么也没说...",
            "date": date,
            "timestamp":[".sv":"timestamp"],
            "imageUrl":"",
            "address":address!,
            "author":[
                "uid":userProfile.uid,
                "username":userProfile.username,
                "photoURL":userProfile.photoURL.absoluteString]
        ] as [String:Any]
        
        postRef.setValue(postObj, withCompletionBlock:{
            error, ref in
            if error == nil{
                
            }else{
                
            }
        })
        
        let imageOne = self.oneImage.image
        if imageOne != nil{
        self.uploadProfileImage(imageOne!){
            url in
            
            let imageOne = (url?.absoluteString)!
            let newObj = ["imageUrl":imageOne]
            
            postRef.updateChildValues(newObj){
                error, ref in
                self.dismiss(animated: true, completion: nil)
            }
        }
            
        }
        else{
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    
    func uploadProfileImage(_ image:UIImage, completion: @escaping((_ url:URL?)->())){
        
        
        let uuid = UUID().uuidString
        
        let storageRef = Storage.storage().reference().child("postFriend/\(uuid)")
        
        guard let imageData = UIImageJPEGRepresentation(image, 0.75) else{
            return
        }
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        storageRef.putData(imageData, metadata: metaData){
            metaData, error in
            if error == nil, metaData != nil{
                //success
                storageRef.downloadURL{(url,error) in
                    guard let downloadURL = url else{
                        print("error")
                        return
                    }
                    if error != nil{
                        completion(nil)
                        return
                    }
                    completion(downloadURL)
                    
                }
            }
            else{
                completion(nil)
            }
        }
    }
    
    
    
    
    
    //上传图片btn
    @IBAction func upload(_ sender: Any) {
        self.present(imagepicker,animated:true,completion:nil)
    }
    
    //照片
    @IBOutlet weak var oneImage: UIImageView!
    
    //填写地址
    @IBOutlet weak var text: UITextView!
    
    
    //交友宣言
    @IBOutlet weak var infor: UITextView!
//    var activeTextField: UITextField!
    
    //选择日期
    @IBOutlet weak var showDate: UILabel!
    @IBOutlet weak var datepicker: UIDatePicker!
    @IBAction func datepicker(_ sender: Any) {
    }
    
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        infor = textField
//    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagepicker = UIImagePickerController()
        imagepicker.allowsEditing = true
        imagepicker.sourceType = .photoLibrary
        imagepicker.delegate = self
        
        let center: NotificationCenter = NotificationCenter.default;
        center.addObserver(self, selector: #selector(keyboardDidShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        center.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    @objc func keyboardDidShow(notification: Notification) {
        let info: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardSize = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardY = self.view.frame.size.height - keyboardSize.height
        let editingTextFieldY:CGFloat! = self.infor.frame.origin.y
        
        if editingTextFieldY > keyboardY - 60 {
            UIView.animate(withDuration: 0.25, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                self.view.frame = CGRect(x: 0, y: self.view.frame.origin.y - (editingTextFieldY!), width: self.view.bounds.width, height: self.view.bounds.height)
            }, completion: nil)
            
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        UIView.animate(withDuration: 0.25, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
            }, completion: nil)
    
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}


extension friendAdVCViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage{
            
            self.oneImage.image = pickedImage
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    
}
