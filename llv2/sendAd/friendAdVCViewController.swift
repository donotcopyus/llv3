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
        
        guard let info = self.infor.text else{
            let alert = UIAlertController(title: title, message: "请输入具体信息", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)

            } ))
            
            present(alert, animated: true, completion: nil)
            return
        }
        
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
    
    //填写地址
    @IBOutlet weak var text: UITextView!
    
    
    //交友宣言
    @IBOutlet weak var infor: UITextView!
    
    //选择日期
    @IBOutlet weak var showDate: UILabel!
    @IBOutlet weak var datepicker: UIDatePicker!
    @IBAction func datepicker(_ sender: Any) {
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
 
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
