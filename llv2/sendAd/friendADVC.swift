//
//  friendADVC.swift
//  llv2
//
//  Created by 林蔼欣 on 2018-09-18.
//  Copyright © 2018 Luna Cao. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher
import ESPullToRefresh



class friendADVC: UIViewController {

    var b2 = dropDownBtn()
    var b3 = dropDownBtn()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        b2 = dropDownBtn.init(frame: CGRect(x:210, y:90, width: 150, height: 40))
        
        b2.setTitle("选择时间", for: .normal)
        
        b2.translatesAutoresizingMaskIntoConstraints = true
        
        b2.dropView.dropDownOptions = ["Weldon Lib","丰盛附近","mason附近","kipps Ln","伦敦DT","Toronto","London","Hamilton","Waterloo","其他","任意"]
        
        self.view.addSubview(b2)
        
        
        b3 = dropDownBtn.init(frame: CGRect(x:210, y:90, width: 150, height: 40))
        
        b3.setTitle("活动地址", for: .normal)
        
        b3.translatesAutoresizingMaskIntoConstraints = true
        
        b3.dropView.dropDownOptions = ["Weldon Lib","丰盛附近","mason附近","kipps Ln","伦敦DT","Toronto","London","Hamilton","Waterloo","其他","任意"]
        
        self.view.addSubview(b3)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    

}
