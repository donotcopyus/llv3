//
//  ratedonation.swift
//  llv2
//
//  Created by Luna Cao on 2018/9/12.
//  Copyright © 2018年 Luna Cao. All rights reserved.
//

import UIKit

class ratedonation: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func rate(_ sender: UIButton) {
        
        //
        
    }
    
    @IBAction func donation(_ sender: UIButton) {
        
        
        
    }
    
    @IBAction func share(_ sender: UIButton) {
    
        UIPasteboard.general.string = "itms-apps://itunes.apple.com/app/id1436232989"
        
        let alert = UIAlertController(title: "分享找啥", message: "已将找啥(FindWhat) appstore链接添加至剪切板，感谢您对找啥的支持 <3", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        } ))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
