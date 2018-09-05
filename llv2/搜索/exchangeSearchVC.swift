//
//  exchangeSearchVC.swift
//  llv2
//
//  Created by 林蔼欣 on 2018-08-20.
//  Copyright © 2018 Luna Cao. All rights reserved.
//

import UIKit
import Firebase

class pidSortExchange{
    var pid:String
    var currencyBol:Bool
    
    init(pid:String,currencyBol:Bool){
        self.pid = pid
        self.currencyBol = currencyBol
    }
}

class exchangeSearchVC: UIViewController {
    
    var pidData = [String]()
    
    var button = dropDownBtn()
    var b2 = dropDownBtn()
    var b3 = dropDownBtn()
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        button = dropDownBtn.init(frame: CGRect(x:50, y:205, width: 100, height: 30))
        
        button.setTitle("求币种", for: .normal)
        
        button.translatesAutoresizingMaskIntoConstraints = true
        
        self.view.addSubview(button)
        
        
        button.dropView.dropDownOptions = ["RMB","加币","美金","港币","日元","英镑"]
        
        //---------------------------------
        b2 = dropDownBtn.init(frame: CGRect(x:185, y:205, width: 100, height: 30))
        
        b2.setTitle("出币种", for: .normal)
        
        b2.translatesAutoresizingMaskIntoConstraints = true
        
        b2.dropView.dropDownOptions = ["RMB","加币","美金","港币","日元","英镑"]
        
        self.view.addSubview(b2)
        
        //----------------------------------
        b3 = dropDownBtn.init(frame: CGRect(x:50, y:140, width: 250, height: 30))
        
        b3.setTitle("排列方式", for: .normal)
        
        b3.translatesAutoresizingMaskIntoConstraints = true
        
        b3.dropView.dropDownOptions = ["最近发布","最久发布","最新发布（仅实时汇率）","最久发布（仅实时汇率)"]
        
        self.view.addSubview(b3)
        
        
    }
    
    
    @IBAction func search(_ sender: UIButton) {
        
        var pidSortArray = [pidSortExchange]()
        
        let want = button.currentTitle!
        let have = b2.currentTitle!
        let order = b3.currentTitle!
        
        
        if (want == "求币种" || have == "出币种"){
            //alert
            let alert = UIAlertController(title: title, message: "出币种或求币种为空", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                return
                
            } ))
            
            present(alert, animated: true, completion: nil)
        }
        if(want == have){
            let alert = UIAlertController(title: title, message: "出币种与求币种相同", preferredStyle: .alert)
            
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
        
        
        let searchRef = Database.database().reference().child("exchange")
        
        searchRef.observe(.value, with: {
            snapshot in
            
            for child in snapshot.children{
                if let childSnapshot = child as? DataSnapshot,
                    let dict = childSnapshot.value as? [String:Any],
                    let haveM = dict["haveMoney"] as? String,
                    let wantM = dict["wantMoney"] as? String,
                    let isCurrency = dict["currencyBol"] as? Bool{
                    
                    if(haveM == have && wantM == want){
                        let currentPost = pidSortExchange(pid:childSnapshot.key, currencyBol: isCurrency)
                        pidSortArray.append(currentPost)
                    }
                }
            }
            
            if (order == "最近发布"){
                pidSortArray = pidSortArray.reversed()
                for element in pidSortArray{
                    self.pidData.append(element.pid)
                }
            }
                
            else if (order == "最久发布"){
                for element in pidSortArray{
                    self.pidData.append(element.pid)
                }
            }
            else if(order == "最新发布（仅实时汇率）"){
                for element in pidSortArray{
                    if element.currencyBol == true{
                        self.pidData.append(element.pid)}}
                self.pidData = self.pidData.reversed()
            }
            else if (order == "最久发布（仅实时汇率)"){
                for element in pidSortArray{
                    if element.currencyBol == true{
                        self.pidData.append(element.pid)}}
            }
            
            if(self.pidData.isEmpty){
                let alert = UIAlertController(title: self.title, message: "没有找到任何符合条件的项目", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                    return
                } ))
                self.present(alert, animated: true, completion: nil)
            }
            else{
                
                let viewController = self.storyboard?.instantiateViewController(withIdentifier: "exchangeSearch") as! exchangeSearch
                
                viewController.pidSearchData = self.pidData
                
                let navC:UINavigationController = UINavigationController(rootViewController: viewController)

                //navC.popViewController(animated: true)
                let backButton = UIBarButtonItem()
                backButton.title = "<"
                navC.navigationBar.topItem?.backBarButtonItem = backButton
                
                self.present(navC, animated: true)
                self.pidData.removeAll()
            }
            
        })
        
    }
    
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
   
    
}

