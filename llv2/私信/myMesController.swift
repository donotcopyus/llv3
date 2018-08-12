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

    @IBAction func back(_ sender: UIBarButtonItem) {
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
                mes.fromId = dict["formId"] as? String
                mes.timestamp = dict["timestamp"] as? Double
                mes.toId = dict["toId"] as? String
                mes.toUname = dict["toUname"] as? String
                mes.toUrl = dict["toUrl"] as? String
                
                //仅显示自己收到的message提示
                if mes.toId == Auth.auth().currentUser?.uid{
                self.messages.append(mes)
                }
                
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
        
        let url = URL(string: message.toUrl!)
        let data = try? Data(contentsOf: url!)
        let image = UIImage(data:data!)
        cell.head.image = image
        
        cell.username.text = message.toUname
        
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
