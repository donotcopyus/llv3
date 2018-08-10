//
//  MessagesHandler.swift
//  llv2
//
//  Created by 林蔼欣 on 2018-07-21.
//  Copyright © 2018 Luna Cao. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage

protocol MessageReceivedDelegate: class {
    func messageReceived(senderID: String, senderName: String, text: String);
}


class MessagesHandler {
    private static let _instance = MessagesHandler();
    private init() {}
    
    weak var delegate: MessageReceivedDelegate?;
    
    
    static var Instance: MessagesHandler {
        return _instance;
    }
    
    func sendMessage(senderID: String, senderName: String, text: String) {
        let data: Dictionary<String, Any> = [Constants.SENDER_ID: senderID, Constants.SENDER_NAME: senderName, Constants.TEXT: text];
        
        DBProvider.Instance.messagesRef.childByAutoId().setValue(data)
    } 
    
    func observeMessages() {
        DBProvider.Instance.messagesRef.observe(DataEventType.childAdded) { (snapshot: DataSnapshot) in
            if var data = snapshot.value as? NSDictionary {
                if var senderID = data[Constants.SENDER_ID] as? String {
                    if var senderName: String = data[Constants.SENDER_NAME] as? String {
                        if var text = data[Constants.TEXT] as? String {
                            self.delegate?.messageReceived(senderID: senderID, senderName: senderName, text: text);
                        }
                    }
                }
            }
        }
    }
    
}
