//
//  ChatVC.swift
//  llv2
//
//  Created by 林蔼欣 on 2018-07-19.
//  Copyright © 2018 Luna Cao. All rights reserved.
//

import UIKit
import MobileCoreServices
import JSQMessagesViewController
import AVKit

class ChatVC: JSQMessagesViewController, MessageReceivedDelegate {
//, UIImagePickerController, UINavigationController, MessageReceivedDelegate {

    
    private var message = [JSQMessage]();
    
    let picker = UIImagePickerController();

    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil);
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        picker.delegate = self as! UIImagePickerControllerDelegate & UINavigationControllerDelegate;
        
        MessagesHandler.Instance.delegate = self;
        
  
        
//        self.senderId = "1"
//        self.senderDisplayName = registerViewController().Instance.userName

        //setupBubbles();
        
        
        MessagesHandler.Instance.observeMessages();
        
//        var self.senderId() = registerViewController().userID();
//        self.senderDisplayName() = OAuthProvider.Instance.userName;
//
//        self.senderId() = OAuthProvider.user.id;
//        self.senderDisplayName = ""
//        setupBubbles()

        //'senderId' and 'senderDisplayName' are no longer properties but are now methods which you must override.
        
        
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let bubbleFactory = JSQMessagesBubbleImageFactory();
        let message = self.message[indexPath.item];
        
        return bubbleFactory.outgoingMessagesBubbleImage(with: UIColor.blue);
    }
//
//    override func collectionView(_ collectionView: (JSQMessagesCollectionView?), avatarImageDataForItemAt indexPath: IndexPath) -> JSQMessageAvatarImageDataSource? {
//        let image = UIImage(named:"demo_avatar_jobs")!
//        let avatar = JSQMessagesAvatarImageFactory().avatarImage(withImage: image, diameter: 30);
//        ////////var a = JSQMessagesAvatarImageFactory.avatarImage(with: UIImage(named: "")!, diameter: 30);
//        return avatar;
//
//    }
    
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData {
        return message[indexPath.item]
    }
        

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int  {
        return message.count;
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as!
        JSQMessagesCollectionViewCell
        return cell;
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        
        MessagesHandler.Instance.sendMessage(senderID: senderId, senderName: senderDisplayName, text: text)
        
        finishSendingMessage();
    }
    
    override func didPressAccessoryButton(_ sender: UIButton) {
        
        //以下是示范例子-----------------------------------------------------------------------------------
        //let alert = UIAlertController(title: "My Alert", message: "This is an alert.", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
//            NSLog("The \"OK\" alert occured.")
//        }))
//        self.present(alert, animated: true, completion: nil)
        //---例子结束-------------------------------------------------------------------------------------
        
        
        let alert = UIAlertController(title: "Media Messages", message: "Please selece a media", preferredStyle: .actionSheet);
        
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil));
    
            alert.addAction(UIAlertAction(title: "Photos", style: .default, handler: { (alert: UIAlertAction) in self.chooseMedia(type: kUTTypeImage)}));
 
            alert.addAction(UIAlertAction(title: "Videos", style: .default, handler: { (alert: UIAlertAction) in self.chooseMedia(type: kUTTypeMovie)}));
        
            self.present(alert, animated: true, completion: nil);
        
        
//-----------------------------------------------------以下是旧的错版本---------------------------
//        let photos = UIActionSheetStyle(title: "Photos", style: UIActionSheetStyle.Default, handler: { (alert: UIAlertAction) in self.chooseMedia(type: kUTTypeImage);})
//
//        let videos = UIActionSheetStyle(title: "Videos", style: UIAlertAction.default, handler: { (alert: UIAlertAction) in self.chooseMedia(type: kUTTypeMovie);})
//
//        alert.addAction(photos);
//        alert.addAction(videos);
//        alert.addAction(cancel);
//        present(alert, animated: true, completion: nil);
        //原本错的旧版本-------------------------------------------------------------------------------
    }
    
    
    
    private func chooseMedia(type: CFString) {
        picker.mediaTypes = [type as String]
        present(picker, animated: true, completion: nil);
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pic = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let img = JSQPhotoMediaItem(image: pic);
            self.message.append(JSQMessage(senderId: senderId(), displayName: senderDisplayName(), media: img))
        }else if let vidRrl = info[UIImagePickerControllerMediaURL] as? URL {
            let video = JSQVideoMediaItem(fileURL: vidRrl, isReadyToPlay: true);
            message.append(JSQMessage(senderId: senderId(), displayName: senderDisplayName(), media: video));
        }
        self.dismiss(animated: true, completion: nil)
        collectionView?.reloadData();
    }
    
    //视频点击播放功能
    override func collectionView(_ collectionView: JSQMessagesCollectionView, didTapMessageBubbleAt indexPath: IndexPath) {
        let msg = message[indexPath.item];
        
        if msg.isMediaMessage{
            if let mediaItem = msg.media as? JSQVideoMediaItem{
                let player = AVPlayer(url: mediaItem.fileURL!);
                let playerController = AVPlayerViewController();
                playerController.player = player;
                self.present(playerController, animated: true, completion: nil);
            }
        }
    }
    
    //Delegation functions
    
    func messageReceived(senderID: String, senderName: String, text: String) {
        message.append(JSQMessage(senderId: senderID, displayName: senderName, text: text));
        collectionView?.reloadData();
    }





}
