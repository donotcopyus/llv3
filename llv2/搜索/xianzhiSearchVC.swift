//
//  xianzhiSearchVC.swift
//  llv2
//
//  Created by 林蔼欣 on 2018-08-20.
//  Copyright © 2018 Luna Cao. All rights reserved.
//

import UIKit

class xianzhiSearchVC: UIViewController {

    @IBOutlet weak var search: UISearchBar!
    
    var b2 = dropDownBtn()
    var b3 = dropDownBtn()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        b2 = dropDownBtn.init(frame: CGRect(x:70, y:140, width: 150, height: 30))
        
        b2.setTitle("选择类型", for: .normal)
        
        b2.translatesAutoresizingMaskIntoConstraints = true
        
        b2.dropView.dropDownOptions = ["书","药妆","家具","租房","服饰","其他"]
        
        self.view.addSubview(b2)
        
        b3 = dropDownBtn.init(frame: CGRect(x:70, y:205, width: 150, height: 30))
        
        b3.setTitle("排列方式", for: .normal)
        
        b3.translatesAutoresizingMaskIntoConstraints = true
        
        b3.dropView.dropDownOptions = ["最近发布","最久发布"]
        
        self.view.addSubview(b3)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    
}
