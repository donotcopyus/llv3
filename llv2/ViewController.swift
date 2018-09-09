//
//  ViewController.swift
//  LunaLauren
//
//  Created by Luna Cao on 2018/7/5.
//  Copyright © 2018年 Luna Cao. All rights reserved.
//

import UIKit
import Firebase
import RevealingSplashView

class ViewController: UIViewController {

    
        @IBOutlet weak var carpool: UIButton!
        @IBOutlet weak var xianzhi: UIButton!
        @IBOutlet weak var other: UIButton!
    
    
    @IBOutlet weak var menuButton: UIBarButtonItem!

   
   
    
    
    override func viewDidLoad() {
        
//        setupViews()
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        
        if self.revealViewController() != nil{
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
 self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
 
        }
        
//        if self.revealViewController() != nil{
//            rightBtn.target = self.revealViewController()
//            rightBtn.action = #selector(SWRevealViewController.rightRevealToggle(_:))
//            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
//    }
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        
        view.addGestureRecognizer(rightSwipe)
        
    }
    
    @objc func handleSwipe(_ sender:UISwipeGestureRecognizer) {
        performSegue(withIdentifier: "goRight2", sender: self)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //click to turn to carpool section
    @IBAction func TurnCarpool(_ sender: UIButton) {
        let carpoolView = CarVC()
        self.navigationController?.pushViewController(carpoolView, animated: true)
    }
    
    //click to turn to xianzhi section
    @IBAction func TurnXianzhi(_ sender: UIButton) {
        let xianzhiView = xianzhiTVC()
  self.navigationController?.pushViewController(xianzhiView, animated: true)
    }
    
     //click to turn to other section
    @IBAction func TurnOther(_ sender: UIButton) {
        let otherView = exchangeTVC()
        self.navigationController?.pushViewController(otherView, animated: true)
    }
    
//    func setupViews() {
//        view.addSubview(revealingSplashView)
//        
//        revealingSplashView.startAnimation()
//    }
//    let revealingSplashView = RevealingSplashView(iconImage: #imageLiteral(resourceName: "harkore"), iconInitialSize: CGSize(width: 123, height: 123), backgroundColor: UIColor.white)
    
    
    
    

    
}

