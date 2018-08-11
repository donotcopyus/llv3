
//
//  vc1.swift
//  llv2
//
//  Created by 林蔼欣 on 2018-08-09.
//  Copyright © 2018 Luna Cao. All rights reserved.
//

import UIKit
import Firebase


//carpool database object




class vc1:  UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //数据库提取
   
    @IBAction func goback(_ sender: UIButton) {
        // self.navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil);
    }
    
}
