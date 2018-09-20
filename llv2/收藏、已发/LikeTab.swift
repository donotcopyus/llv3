//
//  mainTab.swift
//  llv2
//
//  Created by 林蔼欣 on 2018-08-14.
//  Copyright © 2018 Luna Cao. All rights reserved.
//

import UIKit

class LikeTab: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor : UIColor.white], for: .selected)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor : UIColor.darkGray], for: .normal)
        
        let selectedImage1 = UIImage(named: "carpoolTabSelect")?.withRenderingMode(.alwaysOriginal)
        let deSelectedImage1 = UIImage(named: "carpoolTab")?.withRenderingMode(.alwaysOriginal)
        tabBarItem.image = deSelectedImage1
        tabBarItem.selectedImage = selectedImage1
        
        let selectedImage2 = UIImage(named: "xianzhiTabSelect")?.withRenderingMode(.alwaysOriginal)
        let deSelectedImage2 = UIImage(named: "xianzhiTab")?.withRenderingMode(.alwaysOriginal)
        tabBarItem.image = deSelectedImage2
        tabBarItem.selectedImage = selectedImage2
        
        let selectedImage3 = UIImage(named: "exchangeTabSelect")?.withRenderingMode(.alwaysOriginal)
        let deSelectedImage3 = UIImage(named: "exchangeTab")?.withRenderingMode(.alwaysOriginal)
        tabBarItem.image = deSelectedImage3
        tabBarItem.selectedImage = selectedImage3
        
        
        self.selectedIndex = 0

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    


}
