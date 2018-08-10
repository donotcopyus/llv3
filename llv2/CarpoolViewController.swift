//
//  CarpoolViewController.swift
//  LunaLauren
//
//  Created by Luna Cao on 2018/7/5.
//  Copyright © 2018年 Luna Cao. All rights reserved.
//

import UIKit

class CarpoolViewController: UIViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        collectionView?.backgroundColor = UIColor.redColor()
//        collectionView?.registerClass(cellClass: AnyClass?, forCellWithReuseIdentifier: String)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //button to go back to the main
    @IBOutlet weak var back: UIButton!
    @IBAction func goBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
//    //-----------------------------------------------------------------------------
//
//    private let cellId = "cellId"
//
//
//    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 3
//    }
//
//    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
//        return collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath as IndexPath)
//    }
//    }
//
//class FriendCell: UICollectionViewCell {
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupViews()
//    }
//
//    required init?(coder aDecoder: NSCoder){
//        fatalError("error")
//    }
//
//    func

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
