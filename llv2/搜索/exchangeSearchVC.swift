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
    
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        button = dropDownBtn.init(frame: CGRect(x:70, y:205, width: 100, height: 30))
        
        button.setTitle("求币种", for: .normal)
        
        button.translatesAutoresizingMaskIntoConstraints = true
        
        self.view.addSubview(button)
        
        
        button.dropView.dropDownOptions = ["RMB","加币","美金","港币","日元","英镑"]
        
        //---------------------------------
        b2 = dropDownBtn.init(frame: CGRect(x:205, y:205, width: 100, height: 30))
        
        b2.setTitle("出币种", for: .normal)
        
        b2.translatesAutoresizingMaskIntoConstraints = true
        
        b2.dropView.dropDownOptions = ["RMB","加币","美金","港币","日元","英镑"]
        
        self.view.addSubview(b2)
        
        //----------------------------------
        b3 = dropDownBtn.init(frame: CGRect(x:70, y:140, width: 150, height: 30))
        
        b3.setTitle("排列方式", for: .normal)
        
        b3.translatesAutoresizingMaskIntoConstraints = true
        
        b3.dropView.dropDownOptions = ["最近发布","最久发布","最新发布（仅实时汇率）","最久发布（仅实时汇率)"]
        
        self.view.addSubview(b3)
        
        
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

