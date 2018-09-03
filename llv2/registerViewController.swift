//
//  registerViewController.swift
//  LunaLauren
//
//  Created by Luna Cao on 2018/7/13.
//  Copyright © 2018年 Luna Cao. All rights reserved.
//

import UIKit
import Firebase

class registerViewController: UIViewController {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }

    
    var username = "";
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var usernameField: UITextField!
    
    @IBOutlet weak var continueButton: UIButton!
    
    @IBOutlet weak var labelText: UILabel!
    
    var imagePicker: UIImagePickerController!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    
    @IBAction func upload(_ sender: UIButton) {
        
        self.present(imagePicker, animated: true, completion:nil)
        
    }
    
    //user signup
    @IBAction func handleSignUp(_ sender: UIButton) {
        
        guard let username = usernameField.text else {
            //加alert
            print("填写用户名")
            return
        }
        
        guard let email = emailField.text else{
            //加alert
            print("填写邮箱")
            return
        }
        
        guard let pass = passwordField.text else{
            //加alert
            print("填写密码")
            return
        }
        
        guard let image = profileImageView.image else{
            //加alert
            print("请先上传图片")
            return
        }
        

        
        Auth.auth().createUser(withEmail: email, password: pass){
            user,error in
            if error == nil && user != nil {
                
                //加alert
                self.labelText.text = "成功创建！"
                
                
                self.uploadProfileImage(image) {
                    url in
                    
                    if url != nil{
                        
                        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                        changeRequest?.displayName = username
                        changeRequest?.photoURL = url
                        
                        
                        changeRequest?.commitChanges {error in
                        
                            if error == nil{
                                //转到profile
                                
                                self.saveProfile(username: username, profileImageURL: url!){
                                    success in
                                    if success{
                                        //self.performSegue(withIdentifier: "registerComplete", sender: self)
                                    }
                                    else{
                                        print("出问题")
                                    }
                                }
                                
                            }else{
                                return
                        }
                        
                        }}
                    else{
                        return
                    }
                        
                    }


            }
            else{
                
                //加alert
                self.labelText.text = "用户已经存在"
            }
        }
        
    }
    
    
    func saveProfile(username:String, profileImageURL:URL, completion: @escaping((_ success:Bool)->())){
        
        guard let uid = Auth.auth().currentUser?.uid else{
            return
        }
        let databaseRef = Database.database().reference().child("users/profile/\(uid)")
        
        let userObject = [
            "username":username,
            "photoURL":profileImageURL.absoluteString
        ] as [String:Any]
        
        databaseRef.setValue(userObject){
            error, ref in
            completion(error == nil)
        }
        
    }
    
    func usedID() -> String {
                return Auth.auth().currentUser!.uid;
            }
    
    
    func uploadProfileImage(_ image:UIImage, completion: @escaping((_ url:URL?)->())){
        
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}


extension registerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage{
            
            self.profileImageView.image = pickedImage
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    
}
