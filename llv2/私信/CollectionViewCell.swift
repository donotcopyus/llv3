//
//  CollectionViewCell.swift
//  llv2
//
//  Created by Luna Cao on 2018/8/14.
//  Copyright © 2018年 Luna Cao. All rights reserved.
//

import UIKit
import Firebase

class CollectionViewCell: UICollectionViewCell {
    
    let textView:UITextView = {
        let tv = UITextView()
        tv.text = "SAMPLE"
        tv.font = UIFont.systemFont(ofSize: 16)
        return tv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.red
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
