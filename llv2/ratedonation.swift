//
//  ratedonation.swift
//  llv2
//
//  Created by Luna Cao on 2018/9/12.
//  Copyright © 2018年 Luna Cao. All rights reserved.
//

import UIKit
import StoreKit

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
        
        SKStoreReviewController.requestReview()
    }
    
    @IBAction func donation(_ sender: UIButton) {
        
        let newAlert1 = UIAlertController(title:"抱歉",message: "谢谢您的好意，但我们暂时不支持捐赠功能，敬请谅解并期待下个版本～",preferredStyle:.alert)
        newAlert1.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            return
        } ))
        self.present(newAlert1, animated: true, completion: nil)
        
    }
    
    @IBAction func share(_ sender: UIButton) {
        let textToShare = "我在使用一个非常好用的在加华人app，一键发布carpool/闲置/换汇/交友广告，特别酷，你也来试试吧: "
        if let myWebsite = URL(string: "http://itunes.apple.com/app/id1436232989") {//Enter link to your app here
            let objectsToShare = [textToShare, myWebsite] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            //Excluded Activities
            //activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList]
            
            
            activityVC.popoverPresentationController?.sourceView = sender

            self.present(activityVC, animated: true, completion: nil)
        }

    }

}
