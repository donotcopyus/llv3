//
//  xianzhiSearchVC.swift
//  llv2
//
//  Created by 林蔼欣 on 2018-08-20.
//  Copyright © 2018 Luna Cao. All rights reserved.
//

import UIKit

class xianzhiSearchVC: UIViewController {


    
    var b2 = dropDownBtn()
    var button = dropDownBtn()
    
    
    @IBOutlet weak var searchTitle: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        button = dropDownBtn.init(frame: CGRect(x:70, y:140, width: 150, height: 30))
        
        button.setTitle("请选择类型", for: .normal)
        
        button.translatesAutoresizingMaskIntoConstraints = true
        
        self.view.addSubview(button)
        
        
        button.dropView.dropDownOptions = ["二手书","药妆","家具","租房","服饰","其他"]

        b2 = dropDownBtn.init(frame: CGRect(x:70, y:205, width: 150, height: 30))
        
        b2.setTitle("排列方式", for: .normal)
        
        b2.translatesAutoresizingMaskIntoConstraints = true
        
        b2.dropView.dropDownOptions = ["发布时间从早到晚","发布时间从晚到早"]
        
        self.view.addSubview(b2)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func search(_ sender: UIButton) {
    }
    
    
 
}


