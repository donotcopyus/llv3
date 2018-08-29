//
//  xianzhiVController.swift
//  llv2
//
//  Created by Luna Cao on 2018/8/3.
//  Copyright © 2018年 Luna Cao. All rights reserved.
//

import UIKit
import ImagePicker
import Lightbox
import Firebase

class xianzhiVController: UIViewController,UITextViewDelegate,ImagePickerDelegate {
    
    
    
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        guard images.count > 0 else{
            return
        }
        
        let lightboxImage = images.map{
            return LightboxImage(image:$0)
        }
        
        let lightbox = LightboxController(images:lightboxImage, startIndex:0)
        imagePicker.present(lightbox, animated:true, completion: nil)
        
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        
        //用户只上传了一张图片
        if (images.count == 1){
            self.image2.image = images[0]
            self.image.image = nil
            self.image3.image = nil
        }
            //两张
        else if (images.count == 2){
             self.image2.image = nil
            self.image.image = images[0]
            self.image3.image = images[1]
        }
            //三张
        else if(images.count == 3){
        self.image.image = images[0]
        self.image2.image = images[1]
        self.image3.image = images[2]
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
     imagePicker.dismiss(animated:true,completion:nil)
    }
    
    
    
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var image2: UIImageView!
    
    @IBOutlet weak var image3: UIImageView!
    
    @IBOutlet weak var name: UITextField!
    
    @IBOutlet weak var price: UITextField!
    //需要设置只允许数字输入

    @IBOutlet weak var txtv: UITextView!
    
    //placeholder
  
    
    
    @IBAction func upload(_ sender: Any) {
        
        let imagePickerController = ImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.imageLimit = 3
        present(imagePickerController,animated: true, completion: nil)

    }
    
    @IBOutlet weak var wait: UIActivityIndicatorView!
    

    
    @IBAction func send(_ sender: Any) {

        
        //数据库其他行为
        guard let name = self.name.text else{
            return
        }
        
        if (name == ""){
           //alert输入名字
            let alert = UIAlertController(title: title, message: "请输入物品名", preferredStyle: .alert)

            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)

                
            } ))
            
            present(alert, animated: true, completion: nil)
            
            //return
        }
        
        guard let price = self.price.text else{
            return
        }
        
        if(price == ""){
           //alert输入价格--------------------------------------------------
            
            let alert = UIAlertController(title: title, message: "请输入价格", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
                
                
            } ))
            
            present(alert, animated: true, completion: nil)
  
           // end alert -------------------------------------------------------
        }
        
        var extraInfo = self.txtv.text
        
        if extraInfo == "在这里填写详细信息"{
            extraInfo = ""
        }
        
        
        //点击发送时出现的圆圈等待标识
        wait.isHidden = false
        wait.startAnimating()
        
        
        guard let userProfile = UserService.currentUserProfile
            else{
                return
        }
        
        let postRef = Database.database().reference().child("xianzhi").childByAutoId()
        
        let postObj = [
            
            "name":name,
            "price":price,
            "extraInfo":extraInfo ?? "",
            "timestamp":[".sv":"timestamp"],
            "imageOneUrl":"",
            "imageTwoUrl":"",
            "imageThreeUrl":"",
            "author":[
                "uid":userProfile.uid,
                "username":userProfile.username,
                "photoURL":userProfile.photoURL.absoluteString
            ]
            
            ] as [String: Any]
        
        postRef.setValue(postObj, withCompletionBlock:{
            error, ref in
            
            if error == nil{
                //
            }
                
            else{
                //alert, error
                let alert = UIAlertController(title: self.title, message: "出错", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    //                    alert.dismiss(animated: true, completion: nil)
                    return
                } ))
                
 

            }
        })
        
        //第一种情况，只有一张图片（image2)
        if (self.image.image == nil && self.image2.image != nil && self.image3.image == nil){
            
            guard let imageTwo = self.image2.image else{
                return
            }
            //只在内部有效，需要查询先运行里面行数的方法，存值方法
            //或查询storage putdata单独写进来
            
            self.uploadProfileImage(imageTwo){
                url in
                
                let imageTwoUrl = (url?.absoluteString)!
                let imageOneUrl = ""
                let imageThreeUrl = ""
                
                //update 3个image url
                let newObj = ["imageOneUrl":imageOneUrl,
                              "imageTwoUrl":imageTwoUrl,
                              "imageThreeUrl":imageThreeUrl]
                
                postRef.updateChildValues(newObj){
                    error, ref in
                    self.performSegue(withIdentifier: "xianzhiB", sender: self)
                }
                
            }
        }
            
            
            
            //第二种情况，两张图片(image1 和image3）
        else if (self.image.image != nil && self.image2.image == nil && self.image3.image != nil){
            
            guard let imageOne = self.image.image else{
                return
            }
            
            guard let imageThree = self.image3.image else{
                return
            }
            self.uploadProfileImage(imageOne){
                url1 in
                let imageOneUrl = (url1?.absoluteString)!
                self.uploadProfileImage(imageThree){
                    url2 in
                    let imageThreeUrl = (url2?.absoluteString)!
                    let imageTwoUrl = ""
                    //update 3个image url
                    let newObj = ["imageOneUrl":imageOneUrl,
                                  "imageTwoUrl":imageTwoUrl,
                                  "imageThreeUrl":imageThreeUrl]
                    
                    postRef.updateChildValues(newObj){
                        error, ref in
                        self.performSegue(withIdentifier: "xianzhiB", sender: self)
                    }
                    
                    
                }
            }
        }
            
            //第三种情况，三个image都存在
        else if(self.image.image != nil && self.image2.image != nil && self.image3.image != nil){
            
            guard let imageOne = self.image.image else{
                return
            }
            
            guard let imageTwo = self.image2.image else{
                return
            }
            
            guard let imageThree = self.image3.image else{
                return
            }
            
            self.uploadProfileImage(imageOne){
                url1 in
                let imageOneUrl = (url1?.absoluteString)!
                self.uploadProfileImage(imageTwo){
                    url2 in
                    let imageTwoUrl = (url2?.absoluteString)!
                    self.uploadProfileImage(imageThree){
                        url3 in
                        let imageThreeUrl = (url3?.absoluteString)!
                        
                        //update 3个imageurl
                        let newObj = ["imageOneUrl":imageOneUrl,
                                      "imageTwoUrl":imageTwoUrl,
                                      "imageThreeUrl":imageThreeUrl]
                        
                        postRef.updateChildValues(newObj){
                            error, ref in
                            self.performSegue(withIdentifier: "xianzhiB", sender: self)
                        }
                        
                    }
                }
            }
        }
            
        else if (self.image.image == nil && self.image2.image == nil && self.image3.image == nil){
            //update三个imageurl
            self.performSegue(withIdentifier: "xianzhiB", sender: self)
        }
        
    }
    
    
    func uploadProfileImage(_ image:UIImage, completion: @escaping((_ url:URL?)->())){
        
        let uuid = UUID().uuidString
        
        let storageRef = Storage.storage().reference().child("post/\(uuid)")
        
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
    
    
    var b2 = dropDownBtn()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        wait.isHidden = true

          txtv.text = "在这里填写详细信息"
          txtv.textColor = UIColor.lightGray
          txtv.returnKeyType = .done
          txtv.delegate = self
        
        b2 = dropDownBtn.init(frame: CGRect(x:210, y:70, width: 150, height: 40))
        
        b2.setTitle("选择类型", for: .normal)
        
        b2.translatesAutoresizingMaskIntoConstraints = true
        
        b2.dropView.dropDownOptions = ["书","药妆","家具","租房","服饰","其他"]
        
        self.view.addSubview(b2)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "在这里填写详细信息"{
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }


    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"{
            textView.resignFirstResponder()
        }
        return true
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }


}
