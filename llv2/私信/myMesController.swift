//
//  myMesController.swift
//  llv2
//
//  Created by Luna Cao on 2018/8/11.
//  Copyright © 2018年 Luna Cao. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

class myMesController: UITableViewController {

    
    @IBAction func back(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    var messages = [Message]()

    override func viewDidLoad() {
        super.viewDidLoad()

       observeMessages()
    }
    
    func observeMessages(){
        
        let messageRef = Database.database().reference().child("messages")
        
        messageRef.observe(.childAdded, with: { (snapshot) in
            
            if let dict = snapshot.value as? [String:AnyObject]{
                let mes = Message()
                mes.text = dict["text"] as? String
                mes.fromId = dict["fromId"] as? String
                mes.timestamp = dict["timestamp"] as? Double
                mes.toId = dict["toId"] as? String
                mes.toUname = dict["toUname"] as? String
                mes.fromUname = dict["fromUname"] as? String
                mes.toUrl = dict["toUrl"] as? String
                mes.fromUrl = dict["fromUrl"] as? String
                
                //仅显示自己收到和发出去的message提示
                if (mes.toId == Auth.auth().currentUser?.uid || mes.fromId == Auth.auth().currentUser?.uid){
                    
                    //loop一遍messages,查看里面有没有同样的fromId和toId
                    for (index,child) in self.messages.enumerated(){
                        
                        if ((child.fromId == mes.fromId && child.toId == mes.toId) || (child.toId == mes.fromId && child.fromId == mes.toId)){
                            self.messages.remove(at: index)}
                    }
                    
                self.messages.append(mes)
                    
                }
                
                //仅显示最新消息，不会一次把所有消息都列出来
                
                //从新到旧
                self.messages = self.messages.reversed()
                
                DispatchQueue.main.async {
               self.tableView.reloadData()
                }
            }

            }, withCancel: nil)
    }
    
    var receive = true
    
    override func tableView(_ tableView:UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        
        let cell = Bundle.main.loadNibNamed("messageRecCell", owner: self, options: nil)?.first as! messageRecCell
        
        let message = messages[indexPath.row]
        
        if (message.toId == Auth.auth().currentUser?.uid){
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.seconds(1), execute: {
        let url = URL(string: message.fromUrl!)
            
            if (url == URL(string: "default")){
                cell.head.image = #imageLiteral(resourceName: "icon.jpg")
            }
            else{
                cell.head.kf.indicatorType = .activity
                cell.head.kf.setImage(with: url)}}
            )
            
        cell.username.text = message.fromUname
            }
        else{
            
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.seconds(2), execute: {
            let url = URL(string: message.toUrl!)
                        
                        if (url == URL(string: "default")){
                            cell.head.image = #imageLiteral(resourceName: "icon.jpg")
                        }
                        else{
                        cell.head.kf.indicatorType = .activity
                        cell.head.kf.setImage(with: url)}}
            )
                        
                        
            cell.username.text = message.toUname
        }
        
        cell.newestMes.text = message.text
        
        let timeInterval = message.timestamp! / 1000
        let date = NSDate(timeIntervalSince1970: timeInterval)
        let dform = DateFormatter()
        dform.dateFormat = "MM月dd日 HH:mm"
            cell.time.text = dform.string(from:date as Date)
        
        
        
        return cell
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 79.5
    
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return messages.count
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let viewController = storyboard?.instantiateViewController(withIdentifier: "chatLog") as! ChatLogController
        
        let index = tableView.indexPathForSelectedRow?.row
        
        if (messages[index!].fromId! != Auth.auth().currentUser?.uid){
        viewController.uid = messages[index!].fromId!
        viewController.username = messages[index!].fromUname!
        viewController.url = messages[index!].fromUrl!
    }
        else{
           viewController.uid = messages[index!].toId!
            viewController.username = messages[index!].toUname!
            viewController.url = messages[index!].toUrl!
        }

        self.navigationController?.pushViewController(viewController, animated: true)
    }


}
