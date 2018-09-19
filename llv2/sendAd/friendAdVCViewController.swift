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
        
        guard let address = self.text.text else{
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
            
            "info": extrainfo,
            "date": date,
            "timestamp":[".sv":"timestamp"],
            "imageUrl":"",
            "address":address,
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
    
    //选择日期
    @IBOutlet weak var showDate: UILabel!
    @IBOutlet weak var datepicker: UIDatePicker!
    @IBAction func datepicker(_ sender: Any) {
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagepicker = UIImagePickerController()
        imagepicker.allowsEditing = true
        imagepicker.sourceType = .photoLibrary
        imagepicker.delegate = self
 
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
