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

    @IBOutlet weak var headimage: UIImageView!
    @IBOutlet weak var labelText: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.labelText.text = (Auth.auth().currentUser?.displayName)!
        
        guard let uid = Auth.auth().currentUser?.uid else{
            return
        }
    }
        

 @IBOutlet weak var profileButton: UIButton!
    
    @IBAction func handleLogout(_ sender: UIButton) {
        try! Auth.auth().signOut()
        self.performSegue(withIdentifier: "logoutSegue", sender: self)
    }

}


