//
//  profileCheckController.swift
//  llv2
//
//  Created by Luna Cao on 2018/8/8.
//  Copyright © 2018年 Luna Cao. All rights reserved.
//

import UIKit

class profileCheckController: UIViewController {
    
    
    @IBOutlet weak var uidLabel: UILabel!
    
    var uid = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.uidLabel.isHidden = true
        uid = self.uidLabel.text!

        // Do any additional setup after loading the view.
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
