//
//  ContactsVC.swift
//  llv2
//
//  Created by 林蔼欣 on 2018-07-19.
//  Copyright © 2018 Luna Cao. All rights reserved.
//

import UIKit
import Firebase


class ContactsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, FetchData {
    
    @IBOutlet weak var myTable: UITableView!
    
    private let CELL_ID = "Cell"
    private let CHAT_SEGUE = "chatSegue"
    private var contacts = [Contact]();
    
    override func viewDidLoad() {
        super.viewDidLoad()
                // get contact from database.
        //contacts = DBProvider.Instance.getContacts();
        DBProvider.Instance.delegate = self;
        DBProvider.Instance.getContacts();
        
    }
    
    func dataReceived(contacts: [Contact]){
        self.contacts = contacts;
        
        //get the name of current user
        for contact in contacts {
            if contact.id == registerViewController().usedID() {
                registerViewController().username = contact.name;
            }
        }
        
        myTable.reloadData();
    }
    
    ///
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    ///
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count;
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath)
        //cell.textLabel?.text = "THIS WORKS"
        
        cell.textLabel?.text = contacts[indexPath.row].name;
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: CHAT_SEGUE, sender: nil);
    }
    

}
