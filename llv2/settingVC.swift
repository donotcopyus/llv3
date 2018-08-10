//
//  settingVC.swift
//  llv2
//
//  Created by 林蔼欣 on 2018-07-23.
//  Copyright © 2018 Luna Cao. All rights reserved.
//

import UIKit

class settingVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var table: UITableView!
    
    var set:[String] = ["个人资料","账户与安全","浏览记录","隐私设置","新消息提醒","清除缓存","鼓励一下","关于硬核工作室","意见反馈"]

    var setel:[String] = []
    

    
    //return rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.setel.count
    }
    
    //create contents
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identify:String = "cell"
        let cell = table.dequeueReusableCell(withIdentifier: identify, for: indexPath)
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = self.setel[indexPath.row]
        return cell
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 代理
        self.setel = self.set
        self.table.delegate = self
        self.table.dataSource = self
    self.table.register(UITableViewCell.self,forCellReuseIdentifier: "cell")

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil);
    }
    
//
//    @IBAction func jj(_ sender: Any) {
//        let settingPage = sendAdViewContronller()
//        self.navigationController?.pushViewController(settingPage, animated: true)
//    }


}
