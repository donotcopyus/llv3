//
//  UserService.swift
//  llv2
//
//  Created by Luna Cao on 2018/7/30.
//  Copyright © 2018年 Luna Cao. All rights reserved.
//

import Foundation
import Firebase

//观察当前登录用户，获取用户信息
class UserService{
    
    static var currentUserProfile:UserProfile?
    
    static func observeUserProfile(_ uid:String, completion: @escaping((_ userProfile:UserProfile?) -> ())){
        
        let userRef = Database.database().reference().child("users/profile/\(uid)")
        
        userRef.observe(.value, with:{
            snapshot in
            var userProfile:UserProfile?
            
            if let dict = snapshot.value as? [String:Any],
                
                let username = dict["username"] as? String,
            
                let photoURL = dict["photoURL"] as? String,
                
                let url = URL(string:photoURL){
                
                userProfile = UserProfile(uid:snapshot.key, username: username, photoURL:url)
            }
            
            completion(userProfile)
        })
    }
    

    
}


//增加用户field
class UserProfile{
    
    var uid:String
    var username:String
    var photoURL:URL
    
    init(uid:String,username:String,photoURL:URL){
        self.uid = uid
        self.username = username
        self.photoURL = photoURL
    }
    
}
