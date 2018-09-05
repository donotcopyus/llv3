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
    var price:Int
    
    init(pid:String, price:Int){
        self.pid = pid
        self.price = price
    }
}

class xianzhiSearchVC: UIViewController {


    var pidData = [String]()

    var button = dropDownBtn()
    var b2 = dropDownBtn()
    
    
    @IBOutlet weak var searchTitle: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        button = dropDownBtn.init(frame: CGRect(x:50, y:140, width: 150, height: 30))
        
        button.setTitle("请选择类型", for: .normal)
        
        button.translatesAutoresizingMaskIntoConstraints = true
        
        self.view.addSubview(button)
        
        
        button.dropView.dropDownOptions = ["二手书","药妆","家具","租房","服饰","其他","不限类型"]

        b2 = dropDownBtn.init(frame: CGRect(x:50, y:205, width: 150, height: 30))
        
        b2.setTitle("排列方式", for: .normal)
        
        b2.translatesAutoresizingMaskIntoConstraints = true
        
        b2.dropView.dropDownOptions = ["最近发布","最久发布","价格从低到高","价格从高到低"]
        
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
        
        if (self.searchTitle.text == ""){
            let alert = UIAlertController(title: title, message: "请输入搜索名称", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                return
            } ))
            present(alert, animated: true, completion: nil)
        }
        
        
        let searchRef = Database.database().reference().child("xianzhi")
        
        searchRef.observe(.value, with: {snapshot in
            
            for child in snapshot.children{
                if let childSnapshot = child as? DataSnapshot,
                let dict = childSnapshot.value as? [String:Any],
                let type = dict["genre"] as? String,
                let thisPrice = dict["price"] as? String,
                    let objName = dict["name"] as? String{
                    
                    if (type == genre || genre == "不限类型"){
                        if objName.range(of: self.searchTitle.text!) != nil{
                            let priceInt:Int? = Int(thisPrice)
                            let currentPost = pidSortXianzhi(pid: childSnapshot.key, price: priceInt!)
                            pidSortArray.append(currentPost)
                        }
                    }

                }
            }
            
            if (order == "最近发布"){
                pidSortArray = pidSortArray.reversed()
            }
            else if(order == "最久发布"){
            }
            else if (order == "价格从低到高"){
                
                pidSortArray.sort{
                    $0.price < $1.price
                }
                
            }
            else if (order == "价格从高到低"){
                pidSortArray.sort{
                    $0.price > $1.price
                }
            }
            
            for element in pidSortArray{
                self.pidData.append(element.pid)
            }
            
            if(self.pidData.isEmpty){
                let alert = UIAlertController(title: self.title, message: "没有找到任何符合条件的项目", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                    return
                } ))
                self.present(alert, animated: true, completion: nil)
            }
            
            else{
                let viewController = self.storyboard?.instantiateViewController(withIdentifier: "xianzhiSearch") as! xianzhiSearch
                
                viewController.pidSearchData = self.pidData
                
                self.present(viewController, animated: true)
            }
            
        })
        
    }
    
    
 
}


