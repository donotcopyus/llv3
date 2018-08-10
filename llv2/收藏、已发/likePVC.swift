//
//  likePVC.swift
//  llv2
//
//  Created by 林蔼欣 on 2018-08-09.
//  Copyright © 2018 Luna Cao. All rights reserved.
//


import UIKit

class likePVC: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    lazy var subViewControllers:[UIViewController] = {
        return [ UIStoryboard(name:"Main", bundle: nil).instantiateViewController(withIdentifier: "vc1") as! vc1, UIStoryboard(name:"Main", bundle: nil).instantiateViewController(withIdentifier: "xianzhi") as! xianzhi, UIStoryboard(name:"Main", bundle: nil).instantiateViewController(withIdentifier: "exchange") as! exchange]
    }()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        self.dataSource = self

        // Do any additional setup after loading the view.
        
        setViewControllers([subViewControllers[0]], direction: .forward, animated: true, completion: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return subViewControllers.count
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let currentIndex:Int = subViewControllers.index(of: viewController) ?? 0
        
        if currentIndex <= 0 {
            return nil
        }
        return subViewControllers[currentIndex - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let currentIndex:Int = subViewControllers.index(of: viewController) ?? 0
        
        if currentIndex >= (subViewControllers.count - 1) {
            return nil
        }
        return subViewControllers[currentIndex + 1]
    }
    
    
    @IBAction func goback(_ sender: UIButton) {
        // self.navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil);
    }
    
    
}























