//
//  contactUs.swift
//  llv2
//
//  Created by 林蔼欣 on 2018-09-02.
//  Copyright © 2018 Luna Cao. All rights reserved.
//

import UIKit
import MessageUI
import Firebase

class contactUs: UIViewController,MFMailComposeViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        
        view.addGestureRecognizer(rightSwipe)
        
    }
    
    func configureMailController() -> MFMailComposeViewController{
        let mailComoser = MFMailComposeViewController()
        mailComoser.mailComposeDelegate = self
        mailComoser.setToRecipients(["lunacao214@outlook.com","iamlinaixin@gmail.com","harkoreapp@gmail.com"])
        mailComoser.setSubject("HarKore找啥app意见反馈")
        mailComoser.setMessageBody(message.text!, isHTML: false)
        return mailComoser
    }
    
    func showError(){
        let sendMailErrorAlert = UIAlertController(title: "Could not send email", message: "Your device could not send email", preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "Ok", style: .default, handler: nil)
        sendMailErrorAlert.addAction(dismiss)
        self.present(sendMailErrorAlert, animated: true, completion: nil)
    }

    
    @objc func handleSwipe(_ sender:UISwipeGestureRecognizer) {
        performSegue(withIdentifier: "goRight", sender: self)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var message: UITextField!
    
    
    @IBAction func send(_ sender: UIButton) {
        
        let mailCompose = configureMailController()
        if MFMailComposeViewController.canSendMail(){
            self.present(mailCompose, animated: true, completion: nil)
        }
        else{
            showError()
        }
      
        
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
