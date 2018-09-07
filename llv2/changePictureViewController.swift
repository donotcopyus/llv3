//
//  changePictureViewController.swift
//  llv2
//
//  Created by Luna Cao on 2018/7/25.
//  Copyright © 2018年 Luna Cao. All rights reserved.
//

import UIKit
import Firebase

class changePictureViewController: UIViewController {
    
    
    @IBOutlet weak var profilePic: UIImageView!
    
    
    @IBOutlet weak var uploadPic: UIButton!
    @IBOutlet weak var ensureChange: UIButton!
    
    var imagePicker: UIImagePickerController!
    
    
    @IBAction func upload(_ sender: UIButton) {
        self.present(imagePicker,animated:true,completion:nil)
    }
    
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func ensure(_ sender: UIButton) {
        
        guard let image = profilePic.image else{
            //加alert
            print("先上传图片！！！！！！")
            return
        }
        
        self.uploadProfileImage(image){
            url in
            if url != nil{

                self.saveProfile(profileImageURL: url!){
                    success in

                }
                            self.performSegue(withIdentifier: "changeReady", sender: self)
              
            }
            else{
                //上传图片出现问题
            }
        }
    }
    
    
    func saveProfile(profileImageURL:URL, completion: @escaping((_ success:Bool)->())){
        
        guard let uid = Auth.auth().currentUser?.uid else{
            return
        }
        
        let databaseRef = Database.database().reference().child("users/profile/\(uid)")
        let carpoolRef = Database.database().reference().child("carpool")

        let newObj = ["photoURL": profileImageURL.absoluteString]
        
        databaseRef.updateChildValues(newObj){error,ref in
            completion(error == nil)
        }
    
        carpoolRef.observe(.value, with: {
            snapshot in

            for child in snapshot.children{
                if let childSnapshot = child as? DataSnapshot,
                    let dict = childSnapshot.value as? [String:Any],
                        let thisAuthor = dict["author"] as? [String:Any],
                        let thisuid = thisAuthor["uid"] as? String
                    {
                        if (thisuid == uid){
                            carpoolRef.child(childSnapshot.key).child("author").updateChildValues(newObj){error,ref in
                                completion(error == nil)
                            }
                        }
                }

            }
        })
        
        //修改exchange profile

        let exchangeRef = Database.database().reference().child("exchange")
        
        exchangeRef.observe(.value, with: {
            snapshot in
            
            for child in snapshot.children{
                if let childSnapshot = child as? DataSnapshot,
                    let dict = childSnapshot.value as? [String:Any],
                    let thisAuthor = dict["author"] as? [String:Any],
                    let thisuid = thisAuthor["uid"] as? String
                {
                    if (thisuid == uid){
                        exchangeRef.child(childSnapshot.key).child("author").updateChildValues(newObj){error,ref in
                            completion(error == nil)
                        }
                    }
                }
                
            }
        })
        
        //修改xianzhi profile
        
        let xianzhiRef = Database.database().reference().child("xianzhi")

        xianzhiRef.observe(.value, with: {
            snapshot in
            
            for child in snapshot.children{
                if let childSnapshot = child as? DataSnapshot,
                    let dict = childSnapshot.value as? [String:Any],
                    let thisAuthor = dict["author"] as? [String:Any],
                    let thisuid = thisAuthor["uid"] as? String
                {
                    if (thisuid == uid){
                        xianzhiRef.child(childSnapshot.key).child("author").updateChildValues(newObj){error,ref in
                            completion(error == nil)
                        }
                    }
                }
                
            }
        })
        
        let messageRef = Database.database().reference().child("messages")
        let fromObj = ["fromUrl":profileImageURL.absoluteString]
        let toObj = ["toUrl":profileImageURL.absoluteString]

        messageRef.observe(.value, with:{
            snapshot in
            
            for child in snapshot.children{
                if let childSnapshot = child as? DataSnapshot,
                    let dict = childSnapshot.value as? [String:Any],
                    let curFrom = dict["fromId"] as? String,
                    let curTo = dict["toId"] as? String{
                    if(curFrom == uid){
                        messageRef.child(childSnapshot.key).updateChildValues(fromObj)
                    }
                    if(curTo == uid){
                        messageRef.child(childSnapshot.key).updateChildValues(toObj)
                    }
                }
            }
        })
        
        
    }
    
    
    
    func uploadProfileImage (_ image:UIImage, completion:@escaping((_ url:URL?) -> ())){
        
        let alert = UIAlertController(title: "上传", message: "请等待...", preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame:alert.view.bounds)
        loadingIndicator.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        
        alert.view.addSubview(loadingIndicator)
        loadingIndicator.isUserInteractionEnabled = false
        loadingIndicator.startAnimating()
        
        self.present(alert, animated: true, completion: nil)
    
        guard let uid = Auth.auth().currentUser?.uid else{
            return
        }
        
        let storageRef = Storage.storage().reference().child("user/\(uid)")
        guard let imageData = UIImageJPEGRepresentation(image, 0.75) else{
            return
        }
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        storageRef.putData(imageData,metadata:metaData){
            metaData, error in
            
            if error == nil, metaData != nil{
                storageRef.downloadURL{
                    (url, error) in
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension changePictureViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage{
            
            self.profilePic.image = pickedImage
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    
}

