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
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(textView)
        
        textView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        textView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
