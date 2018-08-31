//
//  xianzhiSearchVC.swift
//  llv2
//
//  Created by 林蔼欣 on 2018-08-20.
//  Copyright © 2018 Luna Cao. All rights reserved.
//

import UIKit
import Firebase

class pidSortXianzhi{
    var pid:String
    var price:String
    
    init(pid:String, price:String){
        self.pid = pid
        self.price = price
    }
}

class xianzhiSearchVC: UIViewController {


    var pidData = [String]()
    var b2 = dropDownBtn()
    var button = dropDownBtn()
    
    
    @IBOutlet weak var searchTitle: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        button = dropDownBtn.init(frame: CGRect(x:70, y:140, width: 150, height: 30))
        
        button.setTitle("请选择类型", for: .normal)
        
        button.translatesAutoresizingMaskIntoConstraints = true
        
        self.view.addSubview(button)
        
        
        button.dropView.dropDownOptions = ["二手书","药妆","家具","租房","服饰","其他","不限类型"]

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
        
        var pidSortArray = [pidSortXianzhi]()
        
        let order = b2.currentTitle!
        let genre = button.currentTitle!
        
        if (genre == "请选择类型"){
            let alert = UIAlertController(title: title, message: "搜索类型为空！（tip：如果不限类型搜索，请选择不限类型）", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                return
                
            } ))
            
            present(alert, animated: true, completion: nil)
        }
        
        if(order == "排列方式"){
            //alert
            let alert = UIAlertController(title: title, message: "请选择排序方式", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                return
            } ))
            present(alert, animated: true, completion: nil)
        }
        
        let searchRef = Database.database().reference().child("xianzhi")
        
        searchRef.observe(.value, with: {snapshot in
            
            
            
        })
        
    }
    
    
 
}


