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
