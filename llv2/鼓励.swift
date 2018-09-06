//
//  鼓励.swift
//  llv2
//
//  Created by 林蔼欣 on 2018-09-06.
//  Copyright © 2018 Luna Cao. All rights reserved.
//

import UIKit

class goodgood: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //弹出消息框
        let alertController = UIAlertController(title: "帮忙点个赞憋",
                                                message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "暂不评价", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "好哇(点这个)", style: .default,
                                     handler: {
                                        action in
                                        self.gotoAppStore()
        })
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    //跳转到应用的AppStore页页面
    func gotoAppStore() {
        let urlString = "www.google.ca"
        if let url = URL(string: urlString) {
            //根据iOS系统版本，分别处理
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:],
                                          completionHandler: {
                                            (success) in
                })
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
