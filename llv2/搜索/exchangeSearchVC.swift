//
//  exchangeSearchVC.swift
//  llv2
//
//  Created by 林蔼欣 on 2018-08-20.
//  Copyright © 2018 Luna Cao. All rights reserved.
//

import UIKit
import Firebase

class exchangeSearchVC: UIViewController {
    
    @IBOutlet weak var submit: UIButton!
    
    var button = dropDownBtn()
    var b2 = dropDownBtn()
    var b3 = dropDownBtn()
    
    var currency = false
    


    
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
        b3 = dropDownBtn.init(frame: CGRect(x:70, y:140, width: 100, height: 30))
        
        b3.setTitle("排列方式", for: .normal)
        
        b3.translatesAutoresizingMaskIntoConstraints = true
        
        b3.dropView.dropDownOptions = ["最近发布","最久发布","最新发布（仅实时汇率）","最久发布（仅实时汇率)"]
        
        self.view.addSubview(b3)
        
        
    }
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    
    class dropDownBtn: UIButton, dropDownProtocol {
        
        func dropDownPressed(string: String){
            self.setTitle(string, for: .normal)
            
            // print(self.currentTitle!)
            
            self.dismissDropDown()
        }
        
        //cannot use 'let' here, would cause error in the line 'dropView = dropDownView .....'
        var dropView = dropDownView()
        
        var height = NSLayoutConstraint()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            self.backgroundColor = UIColor.darkGray
            
            dropView = dropDownView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
            
            //for the protocol
            dropView.delegate = self
            
            dropView.translatesAutoresizingMaskIntoConstraints = false
            
        }
        
        override func didMoveToSuperview() {
            self.superview?.addSubview(dropView)
            //how you want the menu to show up
            self.superview?.bringSubview(toFront: dropView)
            dropView.topAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
            dropView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            dropView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
            height = dropView.heightAnchor.constraint(equalToConstant: 0)
        }
        
        var isOpen = false
        
        //if the drop menu is open or not
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            if isOpen == false{
                
                isOpen = true
                
                NSLayoutConstraint.deactivate([self.height])
                
                //用来消除菜单中一条白色线，blank space
                if self.dropView.tableView.contentSize.height > 150 {
                    self.height.constant = 150
                }else{
                    self.height.constant = self.dropView.tableView.contentSize.height
                }
                
                self.height.constant = 150
                
                NSLayoutConstraint.activate([self.height])
                
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                    self.dropView.layoutIfNeeded()
                    //y+= moving down; y-= moving up
                    self.dropView.center.y += self.dropView.frame.height / 2
                }, completion: nil)
            }else{
                
                isOpen = false
                
                NSLayoutConstraint.deactivate([self.height])
                self.height.constant = 0
                
                NSLayoutConstraint.activate([self.height])
                
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                    self.dropView.layoutIfNeeded()
                    self.dropView.center.y -= self.dropView.frame.height / 2
                }, completion: nil)
                
            }
            
        }
        
        //create a function to dismiss the menu
        func dismissDropDown(){
            isOpen = false
            
            NSLayoutConstraint.deactivate([self.height])
            self.height.constant = 0
            
            NSLayoutConstraint.activate([self.height])
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                self.dropView.layoutIfNeeded()
                self.dropView.center.y -= self.dropView.frame.height / 2
            }, completion: nil)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    
    
    class dropDownView: UIView, UITableViewDelegate, UITableViewDataSource {
        var dropDownOptions = [String]()
        
        var tableView = UITableView()
        
        var delegate : dropDownProtocol!
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            tableView.backgroundColor = UIColor.darkGray
            self.backgroundColor = UIColor.darkGray
            
            tableView.delegate = self
            tableView.dataSource = self
            
            tableView.translatesAutoresizingMaskIntoConstraints = false
            
            self.addSubview(tableView)
            
            tableView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
            tableView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
            tableView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        }
        
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        
        
        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return dropDownOptions.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = UITableViewCell()
            
            cell.textLabel?.text = dropDownOptions[indexPath.row]
            cell.backgroundColor = UIColor.darkGray
            
            return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            self.delegate.dropDownPressed(string: dropDownOptions[indexPath.row])
            self.tableView.deselectRow(at: indexPath, animated: true)
            
        }
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
   
    
}

