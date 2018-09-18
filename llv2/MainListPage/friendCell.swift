//
//  friendCell.swift
//  llv2
//
//  Created by 林蔼欣 on 2018-09-18.
//  Copyright © 2018 Luna Cao. All rights reserved.
//


import UIKit
import Firebase

class friendCell: UITableViewCell {
    
    @IBOutlet weak var image1: UIImageView!
    
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image3: UIImageView!
    
    @IBOutlet weak var headImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var namePrice: UILabel!
    @IBOutlet weak var extraInfo: UILabel!
    
    
    @IBOutlet weak var id: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    
    
    @IBOutlet weak var collectionID: UILabel!
    
    @IBOutlet weak var authorID: UILabel!
    
    
    //tap on icon
    override func awakeFromNib() {
        super.awakeFromNib()
        
        headImage.isUserInteractionEnabled = true
        headImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:))))
    }
    
    @objc func imageTapped(_ sender: UITapGestureRecognizer) {
        
        //如何跳转？
        
    }
    
    
    
    @IBAction func like(_ sender: UIButton) {
        
        guard let uid = Auth.auth().currentUser?.uid else{
            return
        }
        
        guard let pid = self.id.text else{
            return
        }
        
        let likedRef = Database.database().reference().child("users/collection/xianzhi/")
        
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
                        self.likeButton.setImage(UIImage(named:"like"), for: .normal)
                        
                        
                        guard let cid = self.collectionID.text else{
                            return}
                        
                        let userLikeRef = Database.database().reference().child("users/collection/xianzhi/\(cid)")
                        userLikeRef.removeValue()
                        liked = true
                        break
                    }}}
            
            if (liked == false){
                let userLikeRef = Database.database().reference().child("users/collection/xianzhi/").childByAutoId()
                
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
                
                self.likeButton.setImage(UIImage(named:"liked"), for: .normal)
                
            }
        })
        
        
    }
    
}

