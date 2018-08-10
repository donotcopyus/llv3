//
//  settingPageVC.swift
//  llv2
//
//  Created by 林蔼欣 on 2018-07-24.
//  Copyright © 2018 Luna Cao. All rights reserved.
//

import Foundation
import UIKit

class TableViewController: UITableViewController {
    
    var names = [String]()
    var identities = [String]()
    
    override func viewDidLoad() {
        names = ["个人资料","账户与安全","浏览记录","隐私设置","新消息提醒","清除缓存","鼓励一下","关于硬核工作室","意见反馈"]
        identities = ["个人资料","账户与安全","浏览记录","隐私设置","新消息提醒","清除缓存","鼓励一下","关于硬核工作室","意见反馈"]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        cell?.textLabel!.text = names[indexPath.row]
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vcName = identities[indexPath.row]
        let viewController = storyboard?.instantiateViewController(withIdentifier: vcName)
        self.navigationController?.pushViewController(viewController!, animated: true)
        
    }
    
}
