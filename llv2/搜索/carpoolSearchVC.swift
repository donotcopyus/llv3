//
//  carpoolSearchVC.swift
//  llv2
//
//  Created by 林蔼欣 on 2018-08-20.
//  Copyright © 2018 Luna Cao. All rights reserved.
//

import UIKit
import Firebase

class carpoolSearchVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
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
    
    var rotationAngle: CGFloat!
    
    @IBOutlet weak var otherDep: UITextField!
    @IBOutlet weak var otherArr: UITextField!
    
    
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
        
        
        button = dropDownBtn.init(frame: CGRect(x:30, y:55, width: 150, height: 40))
        
        button.setTitle("出发城市", for: .normal)
        
        button.translatesAutoresizingMaskIntoConstraints = true
        
        self.view.addSubview(button)
        
        
        
        button.dropView.dropDownOptions = ["Toronto","London","Hamilton","Waterloo","其他"]
        
        
        
        //---------------------------------
        b2 = dropDownBtn.init(frame: CGRect(x:210, y:55, width: 150, height: 40))
        
        b2.setTitle("到达城市", for: .normal)
        
        b2.translatesAutoresizingMaskIntoConstraints = true
        
        b2.dropView.dropDownOptions = ["Toronto","London","Hamilton","Waterloo","其他"]
        
        self.view.addSubview(b2)
        
        
        seatNum.dataSource = self
        seatNum.delegate = self
        
        rotationAngle = -90 * (.pi/180)
        let y = seatNum.frame.origin.y
        seatNum.transform = CGAffineTransform(rotationAngle: rotationAngle)
        
        seatNum.frame = CGRect(x: -100, y: y, width: view.frame.width + 100, height: 100)
        
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    
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
        //view.transform = CGAffineTransform(rotationAngle: (90 * (.pi/180)))
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let view = UIView()
        let label = UILabel()
        //(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view.transform = CGAffineTransform(rotationAngle: (-90 * (.pi / 180)))
        label.textColor = UIColor.white
        return view
    }
    
    
    
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


