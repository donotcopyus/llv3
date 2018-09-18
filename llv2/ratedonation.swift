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
        
        let alert = UIAlertController(title: "五星好评", message: "您将要打开appstore评论界面，", preferredStyle: .actionSheet)
        let confirm = UIAlertAction(title: "确定", style: .default, handler:{ (action) -> Void in
            
         let url = URL(string:"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=1436232989&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8")
            if UIApplication.shared.canOpenURL(url!){
                UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        }
        }
         )
        
        let cancel = UIAlertAction(title:"取消", style:UIAlertActionStyle.cancel, handler: nil)
        alert.addAction(confirm)
        alert.addAction(cancel)
        
        present(alert,animated: true, completion: nil)
        
        
    }
    
    @IBAction func donation(_ sender: UIButton) {
        
        //app内购买
        
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
