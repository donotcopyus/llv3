//
//  carpoolAdViewController.swift
//  LunaLauren
//
//  Created by 林蔼欣 on 2018-07-08.
//  Copyright © 2018 Luna Cao. All rights reserved.
//

import UIKit
import Firebase

class carpoolAdViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
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
    
    
    //横向pickerview 角度：
    var rotationAngle: CGFloat!
    
    @IBOutlet weak var otherDep: UITextField!
    @IBOutlet weak var otherArr: UITextField!
    
    @IBOutlet weak var wait: UIActivityIndicatorView!
    
    
    //handle数据库行为
    @IBAction func sendBtn(_ sender: Any) {
        
        //check出发城市和到达城市，确保field不为空
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
//                    alert.dismiss(animated: true, completion: nil)
                   
                } ))
                
                present(alert, animated: true, completion: nil)
               return
            }
            
            var length = 0
            for char in dept{
                length += "\(char)".lengthOfBytes(using: String.Encoding.utf8) == 3 ? 2: 1
            }
            
            if(length > 8){
                let alert = UIAlertController(title: title, message: "出发城市字符过长，请控制在四个汉字以内", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                    alert.dismiss(animated: true, completion: nil)
                    
                    
                } ))
                
                present(alert, animated: true, completion: nil)
                
                return
            }
        }
        
        if(arri == "其他"){
            
            arri = self.otherArr.text!
            
            //如果没有输入城市名
            if arri == ""{
                //alert
                let alert = UIAlertController(title: title, message: "请填写具体城市", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
//                    alert.dismiss(animated: true, completion: nil)
                   
                } ))
                
                present(alert, animated: true, completion: nil)
               return
            }
            
            var length = 0
            for char in dept{
                length += "\(char)".lengthOfBytes(using: String.Encoding.utf8) == 3 ? 2: 1
            }
            
            if(length > 8){
                let alert = UIAlertController(title: title, message: "到达城市字符过长，请控制在四个汉字以内", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                    alert.dismiss(animated: true, completion: nil)
                    
                    
                } ))
                
                present(alert, animated: true, completion: nil)
                
                return
            }
        }
        
        if(dept == "出发地点" || arri == "到达地点"){
            //alert
            let alert = UIAlertController(title: title, message: "出发或到达地点不能为空", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                //                    alert.dismiss(animated: true, completion: nil)
               
            } ))
            
            present(alert, animated: true, completion: nil)
             return
        }
        
        if (dept == arri){
            let alert = UIAlertController(title: title, message: "出发地点与到达地点相同", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                //                    alert.dismiss(animated: true, completion: nil)
                
            } ))
            
            present(alert, animated: true, completion: nil)
            return
        }
        
        //check剩余座位数和时间，确保field不为空
        let remainSeat = dataSource[seatNum.selectedRow(inComponent: 0)]
        
        
        //format = 7/30/18
        
        let dateFormatter = DateFormatter()
        let timeFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yy-MM-dd"
        
        timeFormatter.timeStyle = DateFormatter.Style.short
        
        let depDate = dateFormatter.string(from: datepicker.date)
        let depTime = timeFormatter.string(from: gotime.date)
        let lateTime = timeFormatter.string(from: latestGo.date)
        
        //确保出发日期比目前日期要晚
        let currentDate = Date()
        let compare = NSCalendar.current.compare(currentDate, to: datepicker.date, toGranularity: .day)
        
        if (compare == ComparisonResult.orderedDescending) {
            //alert
            let alert = UIAlertController(title: title, message: "出发日期或时间已过！", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            } ))
            
            present(alert, animated: true, completion: nil)
                return
        }
        
        //确保timeinterval是合理的
        let checkInterval = gotime.date.compare(latestGo.date)
        if (checkInterval == ComparisonResult.orderedDescending){
            //alert
            let alert = UIAlertController(title: title, message: "出发时间轴不合理", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            } ))
            
            present(alert, animated: true, completion: nil)
            return
        }
        
        //点击发送时出现的圆圈等待标识
  
        let alert = UIAlertController(title: "上传", message: "请等待...", preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame:alert.view.bounds)
        loadingIndicator.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        
        alert.view.addSubview(loadingIndicator)
        loadingIndicator.isUserInteractionEnabled = false
        loadingIndicator.startAnimating()
        
        self.present(alert, animated: true, completion: nil)
        
        //获取当前用户profile
        guard let userProfile = UserService.currentUserProfile
            else{
                return
        }
      
        //handle数据库
        let postRef = Database.database().reference().child("carpool").childByAutoId()
        
        let postObj = [
            
            "depCity":dept,
            "arrCity":arri,
            "remainSeat":remainSeat,
            "depDate":depDate,
            "depTime1":depTime,
            "depTime2":lateTime,
            "timestamp":[".sv": "timestamp"],
            "author":[
                "uid":userProfile.uid,
                "username":userProfile.username,
                "photoURL":userProfile.photoURL.absoluteString
            ]
            
            ] as [String:Any]
        
 
        //  func sendData() {
        postRef.setValue(postObj, withCompletionBlock: {error, ref in

            if error == nil {
                alert.dismiss(animated: true, completion: nil)
                self.performSegue(withIdentifier: "goB", sender: self)
                
            }
            else{
                //alert, error
                let alert = UIAlertController(title: self.title, message: "出错", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    //                    alert.dismiss(animated: true, completion: nil)

                } ))
                 self.present(alert, animated: true, completion: nil)
                 return
            }
        })

        
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
        
        //隐藏等待的圆圈loading
        wait.isHidden = true
        
        
        button = dropDownBtn.init(frame: CGRect(x:30, y:90, width: 150, height: 40))
        
        button.setTitle("出发地点", for: .normal)
        
        button.translatesAutoresizingMaskIntoConstraints = true
        
        self.view.addSubview(button)
        
        
        
        button.dropView.dropDownOptions = ["Weldon Lib","丰盛附近","mason附近","kipps Ln","伦敦DT","Toronto","London","Hamilton","Waterloo","其他","任意"]
        
        
        
        //---------------------------------
        b2 = dropDownBtn.init(frame: CGRect(x:210, y:90, width: 150, height: 40))
        
        b2.setTitle("到达地点", for: .normal)
        
        b2.translatesAutoresizingMaskIntoConstraints = true
        
        b2.dropView.dropDownOptions = ["Weldon Lib","丰盛附近","mason附近","kipps Ln","伦敦DT","Toronto","London","Hamilton","Waterloo","其他","任意"]
        
        self.view.addSubview(b2)
        
        
        seatNum.dataSource = self
        seatNum.delegate = self
        
//        rotationAngle = -90 * (.pi/180)
//        let y = seatNum.frame.origin.y
//        seatNum.transform = CGAffineTransform(rotationAngle: rotationAngle)
//
//        seatNum.frame = CGRect(x: 0, y: y, width: 20, height: 20)
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))

        view.addGestureRecognizer(rightSwipe)
        
    }
    
    @objc func handleSwipe(_ sender:UISwipeGestureRecognizer) {
        performSegue(withIdentifier: "goRight", sender: self)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    
    //lauren————————————————————————————————————————————————————————————
    //button to go back to main

    
    //---------剩余座位数------------------------------------------
    @IBOutlet weak var seat: UILabel!
    
    @IBOutlet weak var seatNum: UIPickerView!
    
    private let dataSource = ["1","2","3","4","5","6"]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSource.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        seat.text = "剩余座位数：\(dataSource[row])"
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataSource[row]
//        view.transform = CGAffineTransform(rotationAngle: (90 * (.pi/180)))
    }
//
//

//    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
//
//        let view = UIView()
//        let label = UILabel()
////       (frame: CGRect(x: 0, y: 0, width: 100, height: 100))
////        view.transform = CGAffineTransform(rotationAngle: (-90 * (.pi / 180)))
//        label.textColor = UIColor.black
//        return view
//    }
    

    
    
    
    //date label
    @IBOutlet weak var godate: UILabel!
    @IBOutlet weak var datepicker: UIDatePicker!
    
    @IBAction func datepicker(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.short
        
        let strDate = dateFormatter.string(from: datepicker.date)
        godate.text = "出发日期 \(strDate)"
    }
    
    
    
    //time label
    @IBOutlet private weak var showGoTime: UILabel!
    //time picker
    @IBOutlet weak var gotime: UIDatePicker!
    
    @IBAction func gotime(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        
        dateFormatter.timeStyle = DateFormatter.Style.short
        
        let strDate = dateFormatter.string(from: gotime.date)
        showGoTime.text = "从 \(strDate)至"
    }
    
    //latest go time label
    @IBOutlet private weak var latestGoTime: UILabel!
    //latest go time
    @IBOutlet weak var latestGo: UIDatePicker!
    
    @IBAction func latestGo(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        
        //    dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.short
        
        let strDate = dateFormatter.string(from: latestGo.date)
        latestGoTime.text = "至 \(strDate)之间出发"
    }
}


protocol dropDownProtocol {
    func dropDownPressed(string: String)
}

class dropDownBtn: UIButton, dropDownProtocol {
    
    
    
    func dropDownPressed(string: String){
        
        self.setTitle(string, for: .normal)
        self.dismissDropDown()
    }
    
    
    var dropView = dropDownView()
    
    var height = NSLayoutConstraint()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.lightGray
        
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














