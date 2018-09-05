//
//  carpoolSearchVC.swift
//  llv2
//
//  Created by 林蔼欣 on 2018-08-20.
//  Copyright © 2018 Luna Cao. All rights reserved.
//

import UIKit
import Firebase

class pidSort{
    var pid: String
    var depTime: Date
    
    init (pid:String, depTime:Date){
        self.pid = pid
        self.depTime = depTime
    }
}

class carpoolSearchVC: UIViewController {

    var pidData = [String]()
    


    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    var subm = 0
    
    var button = dropDownBtn()
    var b2 = dropDownBtn()
    var b3 = dropDownBtn()
    
    
    var rotationAngle: CGFloat!
    
    @IBOutlet weak var otherDep: UITextField!
    @IBOutlet weak var otherArr: UITextField!
    
    //date label
    @IBOutlet weak var godate: UILabel!
    @IBOutlet weak var datepicker: UIDatePicker!
    
    @IBAction func datepicker(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.short
        
        let strDate = dateFormatter.string(from: datepicker.date)
        godate.text = "出发日期 \(strDate)"
    }
    

    
    @IBAction func dChanged(_ sender: UITextField) {
        
        if(button.currentTitle! != "其他"){
            button.setTitle("其他", for: .normal)
        }
        
        otherDep.text = sender.text
        
    }
    
    
    @IBAction func aChanged(_ sender: UITextField) {
        
        if(b2.currentTitle! != "其他"){
            b2.setTitle("其他", for: .normal)
        }
        
        otherArr.text = sender.text
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        button = dropDownBtn.init(frame: CGRect(x:50, y:205, width: 150, height: 30))
        
        button.setTitle("出发城市", for: .normal)
        
        button.translatesAutoresizingMaskIntoConstraints = true
        
        self.view.addSubview(button)
    
        
        button.dropView.dropDownOptions = ["Toronto","London","Hamilton","Waterloo","其他","任意"]
        
        
        
        //---------------------------------
        b2 = dropDownBtn.init(frame: CGRect(x:205, y:205, width: 150, height: 30))
        
        b2.setTitle("到达城市", for: .normal)
        
        b2.translatesAutoresizingMaskIntoConstraints = true
        
        b2.dropView.dropDownOptions = ["Toronto","London","Hamilton","Waterloo","其他","任意"]
        
        self.view.addSubview(b2)
        
        ///---------------------------------------
        b3 = dropDownBtn.init(frame: CGRect(x:50, y:140, width: 200, height: 30))
        
        b3.setTitle("排列方式", for: .normal)
        
        b3.translatesAutoresizingMaskIntoConstraints = true
        
        b3.dropView.dropDownOptions = ["最近发布","最久发布","出发时间从早到晚","出发时间从晚到早"]
        
        self.view.addSubview(b3)
   
    }

    
    @IBAction func search(_ sender: UIButton) {

        var pidSortArray = [pidSort]()
        
        var dept = button.currentTitle!
        var arri = b2.currentTitle!
        
        
        //如果选择了其他，则变为其他出发城市
        if(dept == "其他"){
            dept = self.otherDep.text!
            //如果没有输入城市名
            if dept == ""{
                //alert
                let alert = UIAlertController(title: title, message: "请填写具体城市", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    return
                } ))
                present(alert, animated: true, completion: nil)}}
        if(arri == "其他"){
            arri = self.otherArr.text!
            //如果没有输入城市名
            if arri == ""{
                //alert
                let alert = UIAlertController(title: title, message: "请填写具体城市", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    return
                } ))
                present(alert, animated: true, completion: nil)}}
        
        if(dept == "出发城市" || arri == "到达城市"){
            //alert
            let alert = UIAlertController(title: title, message: "出发或到达城市不能为空（tips:如果不需要设置出发或到达城市限制，请选择‘任意’）", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                return
            } ))
            present(alert, animated: true, completion: nil)
        }
        
        //出发日期
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy-MM-dd"
        let depDate = dateFormatter.string(from:datepicker.date)
        
        let currentDate = Date()
        let compare = NSCalendar.current.compare(currentDate, to: datepicker.date, toGranularity: .day)
        
        if (compare == ComparisonResult.orderedDescending) {
            //alert
            let alert = UIAlertController(title: title, message: "出发日期或时间已过！", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                return} ))
            present(alert, animated: true, completion: nil)}
        
        //排序方式，从早到晚或者从晚到早，最新发布最晚发布
        //根据排序方式reorder
        let order = b3.currentTitle!
        if(order == "排列方式"){
            //alert
            let alert = UIAlertController(title: title, message: "请选择排序方式", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                return
            } ))
            present(alert, animated: true, completion: nil)
        }
        
        //dept是出发城市，arri是到达城市，“任意”为没有限制
        //出发日期需要一个默认值，depDate是出发日期
        
        //搜索具体！
        let searchRef = Database.database().reference().child("carpool")
        
        searchRef.observe(.value, with:{
            snapshot in
            
            for child in snapshot.children{
                if let childSnapshot = child as? DataSnapshot,
                let dict = childSnapshot.value as? [String:Any],
                let arrCity = dict["arrCity"] as? String,
                let depCity = dict["depCity"] as? String,
                let departureDate = dict["depDate"] as? String,
                let depTime1 = dict["depTime1"] as? String{
                
                  //check 出发和到达城市
                    if( (arri == arrCity && dept == depCity && departureDate == depDate) || (arri == "任意" && dept == depCity && departureDate == depDate) || (dept == "任意" && arri == arrCity && departureDate == depDate) || (arri == "任意" && dept == "任意" && departureDate == depDate)) {
                        
                        let form = DateFormatter()
                        form.timeStyle = DateFormatter.Style.short
                        let time = form.date(from: depTime1)

                        
                        let currentPost = pidSort(pid:childSnapshot.key,depTime: time!)
                        pidSortArray.append(currentPost)
                    }
                }
            }
            
            //排序
            if (order == "最近发布"){
                pidSortArray = pidSortArray.reversed()}
                
            else if (order == "最久发布"){
                //顺序不变
            }
            else if(order == "出发时间从早到晚"){
                
                pidSortArray.sort(by:{
                    $0.depTime.compare($1.depTime) == .orderedAscending
                }
                )
            }
            
            else if (order == "出发时间从晚到早"){
                
                pidSortArray.sort(by:{
                    $0.depTime.compare($1.depTime) == .orderedDescending
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
                
                //跳转f，传值
                let viewController = self.storyboard?.instantiateViewController(withIdentifier: "carpoolSearch") as! carpoolSearch
                
                viewController.pidSearchData = self.pidData
                
                let navC:UINavigationController = UINavigationController(rootViewController: viewController)
                
                //navC.popViewController(animated: true)
                viewController.navigationItem.leftItemsSupplementBackButton = true
                viewController.navigationItem.leftBarButtonItem?.title = "<Back"
                
                self.present(navC, animated:true)
                 self.pidData.removeAll()
            }

        })
        
    }


    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    }
    
    




