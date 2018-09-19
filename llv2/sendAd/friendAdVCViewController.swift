//
//  friendAdVCViewController.swift
//  llv2
//
//  Created by 林蔼欣 on 2018-09-18.
//  Copyright © 2018 Luna Cao. All rights reserved.
//

import UIKit

class friendAdVCViewController: UIViewController{
    
    //发送btn
    @IBAction func send(_ sender: Any) {
        
    }
    //上传图片btn
    @IBAction func upload(_ sender: Any) {
    }
    
    //照片
    @IBOutlet weak var oneImage: UIImageView!
    
    //交友宣言
    @IBOutlet weak var infor: UITextView!
    
    //选择日期
    @IBOutlet weak var godate: UILabel!
    @IBOutlet weak var datepicker: UIDatePicker!
    
    @IBAction func datepicker(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.short
        
        let strDate = dateFormatter.string(from: datepicker.date)
        godate.text = "出发日期 \(strDate)"
    }
    
    
    
    var b3 = dropDownBtn()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        b3 = dropDownBtn.init(frame: CGRect(x:210, y:90, width: 150, height: 30))
        
        b3.setTitle("活动地址", for: .normal)
        
        b3.translatesAutoresizingMaskIntoConstraints = true
        
        b3.dropView.dropDownOptions = ["Weldon Lib","丰盛附近","mason附近","kipps Ln","伦敦DT","Toronto","London","Hamilton","Waterloo","其他","任意"]
        
        self.view.addSubview(b3)
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
