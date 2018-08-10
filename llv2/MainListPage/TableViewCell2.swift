//
//  TableViewCell2.swift
//  llv2
//
//  Created by 林蔼欣 on 2018-07-27.
//  Copyright © 2018 Luna Cao. All rights reserved.
//

import UIKit
import Firebase

class TableViewCell2: UITableViewCell {

    @IBOutlet weak var headImage: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var sendTimeLabel: UILabel!
    
    @IBOutlet weak var depatureC: UILabel!
    @IBOutlet weak var arriveC: UILabel!
    
    @IBOutlet weak var date: UILabel!
    
    @IBOutlet weak var time1: UILabel!
    @IBOutlet weak var time2: UILabel!
    
    
    @IBOutlet weak var seatLabel: UILabel!
    
    @IBOutlet weak var id: UILabel!
    
    @IBOutlet weak var collectionID: UILabel!
    
    @IBOutlet weak var likedButton: UIButton!

    
    @IBAction func like(_ sender: UIButton) {
        
        guard let uid = Auth.auth().currentUser?.uid else{
            return
        }
        
        guard let pid = self.id.text else{
            return
        }
        
        let likedRef = Database.database().reference().child("users/collection/carpool/")
        
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
                        self.likedButton.setTitle("💗", for: .normal)
                        
                        guard let cid = self.collectionID.text else{
                            return}
                        
                        let userLikeRef = Database.database().reference().child("users/collection/carpool/\(cid)")
                        userLikeRef.removeValue()
                        liked = true
                        break
                    }}}
            
            if (liked == false){
                let userLikeRef = Database.database().reference().child("users/collection/carpool/").childByAutoId()
                
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
                
                self.likedButton.setTitle("❤️", for: .normal)
            }
        })
        
        
        
    }
    
}
