//
//  friendAdVCViewController.swift
//  llv2
//
//  Created by 林蔼欣 on 2018-09-18.
//  Copyright © 2018 Luna Cao. All rights reserved.
//

import UIKit
import Firebase

class friendAdVCViewController: UIViewController{
    
    var imagepicker: UIImagePickerController!
    
    
    //发送btn
    @IBAction func send(_ sender: Any) {
        
        let extrainfo = self.infor.text
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy-MM-dd"
        let date = dateFormatter.string(from: datepicker.date)
        
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
        
        
        
        
    }
    
    
    //上传图片btn
    @IBAction func upload(_ sender: Any) {
        self.present(imagepicker,animated:true,completion:nil)
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
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
 
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
