//
//  personalVC.swift
//  llv2
//
//  Created by 林蔼欣 on 2018-08-04.
//  Copyright © 2018 Luna Cao. All rights reserved.
//

import UIKit
import Firebase

class personalVC: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!


    @IBOutlet weak var labelText: UILabel!
    
   
    @IBAction func nicknameChange(_ sender: UIButton) {
    }
    
    @IBAction func passwordChange(_ sender: UIButton) {
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.labelText.text = "欢迎，" + (Auth.auth().currentUser?.displayName)!
        
        guard let uid = Auth.auth().currentUser?.uid else{
            return
        }
        
        //handle showing the profile image
        let databaseRef = Database.database().reference().child("users/profile/\(uid)")
        let refHandle = databaseRef.observe(DataEventType.value, with:{
            (snapshot) in
            let curUser = snapshot.value as? NSDictionary
            let urlString = curUser?["photoURL"] as? String ?? ""
            
            let url = URL(string:urlString)
            let data = try? Data(contentsOf:url!)
            self.profileImageView.image = UIImage(data:data!)

            
        })
        


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func handleLogout(_ sender: UIButton) {
        try! Auth.auth().signOut()
        self.performSegue(withIdentifier: "logoutSegue", sender: self)
    }
}


//
