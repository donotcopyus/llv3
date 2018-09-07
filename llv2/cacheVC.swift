//
//  cacheVC.swift
//  llv2
//
//  Created by 林蔼欣 on 2018-08-18.
//  Copyright © 2018 Luna Cao. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

class cacheVC: UIViewController {
    
    let cache = KingfisherManager.shared.cache
    
    @IBAction func clearCache(_ sender: Any) {
        
        cache.clearMemoryCache()
        cache.clearDiskCache()
        cache.cleanExpiredDiskCache()
        
        let alert = UIAlertController(title: title, message: "清除缓存成功！", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        } ))
        
        present(alert, animated: true, completion: nil)
        
    }
    



    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
