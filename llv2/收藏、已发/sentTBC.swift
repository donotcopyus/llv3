//
//  sentTBC.swift
//  llv2
//
//  Created by 林蔼欣 on 2018-08-10.
//  Copyright © 2018 Luna Cao. All rights reserved.
//

import UIKit

class sentTBC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBar()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
       
        // Dispose of any resources that can be recreated.
    }
    func setupTabBar() {
        
        
        
        let Carpool = createNavController(vc: vc1())
        
        let Xianzhi = createNavController(vc: xianzhi())
        let Exchange = createNavController(vc: exchange())
        
        guard let items = tabBar.items else {
            return
        }
        
        for item in items {
            item.imageInsets = UIEdgeInsetsMake(4, 0, -4, 0)
        }
    }
    
}
extension UITabBarController {
    func createNavController(vc: UIViewController) -> UINavigationController {
        let viewController = vc
        let navController = UINavigationController(rootViewController: viewController)
        //navController.tabBarItem.image = unselected
        //navController.tabBarItem.selectedImage = selected
        return navController
    }
}



