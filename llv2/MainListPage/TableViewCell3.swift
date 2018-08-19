//
//  TableViewCell3.swift
//  llv2
//
//  Created by 林蔼欣 on 2018-07-28.
//  Copyright © 2018 Luna Cao. All rights reserved.
//

import UIKit
import Firebase

class TableViewCell3: UITableViewCell {

    
    @IBOutlet weak var mainimage: UIImageView!
    
    @IBOutlet weak var mainlabel: UILabel!
    @IBOutlet weak var sendtimelb: UILabel!
    @IBOutlet weak var detaillb: UILabel!
    
    @IBOutlet weak var extraInformartion: UILabel!
    
    @IBOutlet weak var isCur: UILabel!
    
    @IBOutlet weak var id: UILabel!
    
    @IBOutlet weak var collectionID: UILabel!
    
    @IBOutlet weak var likeButton: UIButton!
    
    
    @IBAction func like(_ sender: UIButton) {
        
        
        guard let uid = Auth.auth().currentUser?.uid else{
            return
        }
        
        guard let pid = self.id.text else{
            return
        }
        
        let likedRef = Database.database().reference().child("users/collection/exchange/")
        
        var liked = false
        
        likedRef.observeSingleEvent(of:.value, with:{
            snapshot in
            
            for child in snapshot.children{
                if let childSnapshot = child as? DataSnapshot,
                    let dict = childSnapshot.value as? [String:Any],
                    let thispid = dict["pid"] as? String,
                    let thisuid = dict["uid"] as? String{
                    
                    //如果已经被like
                    if(thisuid == uid && thispid == pid){
                        //删除收藏
                        self.likeButton.setTitle("💗", for: .normal)
                        
                        guard let cid = self.collectionID.text else{
                            return}
                        
                        let userLikeRef = Database.database().reference().child("users/collection/exchange/\(cid)")
                        userLikeRef.removeValue()
                        liked = true
                        break
                    }}}
            
            if (liked == false){
                let userLikeRef = Database.database().reference().child("users/collection/exchange/").childByAutoId()
                
                let likeObj = [
                    "pid": pid,
                    "uid": uid
                    ] as [String:Any]
                
                userLikeRef.setValue(likeObj,withCompletionBlock:{
                    error, ref in
                    
                    if error == nil{
                        //alert
                        self.collectionID.text = ref.key
                    }
                        
                    else{
                        //alert
                        return}})
                
                self.likeButton.setTitle("❤️", for: .normal)
            }
        })
        
    }
    
    
}
