//
//  draftLike.swift
//  llv2
//
//  Created by 林蔼欣 on 2018-08-12.
//  Copyright © 2018 Luna Cao. All rights reserved.
//

import UIKit

class draftLike: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    lazy var subViewControllers:[UITableViewController] = {
        return [ UIStoryboard(name:"Main", bundle: nil).instantiateViewController(withIdentifier: "dra1") as! dra1, UIStoryboard(name:"Main", bundle: nil).instantiateViewController(withIdentifier: "dra2") as! dra2]
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
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter TableViewController: UITableViewController) -> UITableViewController? {
        let currentIndex:Int = subViewControllers.index(of: TableViewController) ?? 0
        
        if currentIndex <= 0 {
            return nil
        }
        return subViewControllers[currentIndex - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter TableViewController: UITableViewController) -> UITableViewController? {
        let currentIndex:Int = subViewControllers.index(of: TableViewController) ?? 0
        
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
