//
//  myMesController.swift
//  llv2
//
//  Created by Luna Cao on 2018/8/11.
//  Copyright © 2018年 Luna Cao. All rights reserved.
//

import UIKit
import Firebase

class myMesController: UITableViewController {


    @IBAction func back(_ sender: UIButton) {
    self.dismiss(animated: true, completion: nil)
    }

    
    var messages = [Message]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = Auth.auth().currentUser?.displayName

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
                
                //仅显示自己收到的message提示
                if (mes.toId == Auth.auth().currentUser?.uid){
                    
                    //loop一遍messages,查看里面有没有同样的fromId和toId
                    for (index,child) in self.messages.enumerated(){
                        
                        if child.fromId == mes.fromId && child.toId == mes.toId{
                            self.messages.remove(at: index)                        }
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
    
    override func tableView(_ tableView:UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        
        let cell = Bundle.main.loadNibNamed("messageRecCell", owner: self, options: nil)?.first as! messageRecCell
        
        let message = messages[indexPath.row]
        
        let url = URL(string: message.fromUrl!)
        let data = try? Data(contentsOf: url!)
        let image = UIImage(data:data!)
        cell.head.image = image
        cell.username.text = message.fromUname
        cell.newestMes.text = message.text
        
        return cell
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return messages.count
    }


}
