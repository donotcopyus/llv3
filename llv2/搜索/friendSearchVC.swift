//  Created by Luna Cao on 2018/9/20.
//  Copyright © 2018年 Luna Cao. All rights reserved.
//  Created by 林蔼欣 on 2018-08-31.
//  Copyright © 2018 Luna Cao. All rights reserved.
//

import UIKit
import Firebase


class pidSortFriend{
    var pid:String
    var date:Date
    
    init(pid:String, date:Date){
        self.pid = pid
        self.date = date
    }
}



class friendSearchVC: UIViewController {
    
    
    
    
    @IBOutlet weak var keyword: UITextField!
    
    @IBAction func search(_ sender: Any) {
        
        var pidSortArray = [pidSortFriend]()
        let order = button.currentTitle!
        
        if(order == "排列方式"){
            //alert
            let alert = UIAlertController(title: title, message: "请选择排序方式", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                return
            } ))
            present(alert, animated: true, completion: nil)
            return
        }

        if (self.keyword.text == ""){
            self.keyword.text = "不限"
        }
        
        let searchRef = Database.database().reference().child("friend")
        
        searchRef.observe(.value, with: {snapshot in
            
            for child in snapshot.children{
                if let childSnapshot = child as? DataSnapshot,
                    let dict = childSnapshot.value as? [String:Any],
                    let date1 = dict["date"] as? String,
                    let title = dict["info"] as? String{
                    
                    let form = DateFormatter()
                    form.timeStyle = DateFormatter.Style.short
                    
            
                    if (title.range(of: self.keyword.text!) != nil) || (self.keyword.text! == "不限"){
                        
                        let form = DateFormatter()
                        form.dateFormat = "yy-MM-dd"
                        let time = form.date(from: date1)
                        
                        let currentPost = pidSortFriend(pid: childSnapshot.key, date: time!)
                        pidSortArray.append(currentPost)
                    }
                    
                }
            }
            
            if (order == "最近发布"){
                pidSortArray = pidSortArray.reversed()
            }
            else if(order == "最久发布"){
            }
            else if (order == "举行时间从早到晚"){
                
                pidSortArray.sort(by:{
                    $0.date.compare($1.date) == .orderedAscending
                }
                )
                
            }
            else if (order == "举行时间从晚到早"){
                pidSortArray.sort(by:{
                    $0.date.compare($1.date) == .orderedDescending
                }
                )
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
                let viewController = self.storyboard?.instantiateViewController(withIdentifier: "friendSearch") as! friendSearch
                
                viewController.pidSearchData = self.pidData
                
                let navC:UINavigationController = UINavigationController(rootViewController: viewController)
                viewController.navigationItem.leftItemsSupplementBackButton = true
                viewController.navigationItem.title = "搜索结果"
                viewController.navigationItem.leftBarButtonItem?.image = UIImage(named:"backbtn")
                self.present(navC, animated: true)
                self.pidData.removeAll()
            }
            
        })
        
    }
    
    
    var pidData = [String]()
    var button = dropDownBtn()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        button = dropDownBtn.init(frame: CGRect(x:50, y:140, width: 150, height: 30))
        
        button.setTitle("排列方式", for: .normal)
        
        button.translatesAutoresizingMaskIntoConstraints = true
        
        button.dropView.dropDownOptions = ["最近发布","最久发布","举行时间从早到晚","举行时间从晚到早"]
        
        self.view.addSubview(button)}

        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        

        
}
