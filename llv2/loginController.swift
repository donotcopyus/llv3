//
//  loginController.swift
//  LunaLauren
//
//  Created by Luna Cao on 2018/7/11.
//  Copyright © 2018年 Luna Cao. All rights reserved.
//

import UIKit
import Firebase
import RevealingSplashView


class loginController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var passField: UITextField!
    
    @IBOutlet weak var labelText: UILabel!
    
    
    @IBAction func handleSignin(_ sender: UIButton) {
        
        guard let email = emailField.text else{
            return
        }
        
        guard let pass = passField.text else{
            return
        }
        
        Auth.auth().signIn(withEmail: email, password:pass){
            user, error in
            if error == nil && user != nil{
                self.performSegue(withIdentifier: "loggedin", sender: self)
            }
            else{
                let alert = UIAlertController(title: self.title, message: "登录失败，用户名或密码错误", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                    alert.dismiss(animated: true, completion: nil)
                } ))
                
                self.present(alert, animated: true, completion: nil)
                
                return
            }
        }
    }
    
    
    
    @IBAction func forgetPass(_ sender: UIButton) {

    }
    
    
    @IBAction func register(_ sender: UIButton) {
        
        let xieyi = """
         欢迎使用找啥FindWhat,在开始使用前，您需要同意以下协议：

         一.用户个人信息保护
          1.1 保护用户个人信息是找啥的基本原则，找啥会采取合理的措施保护用户的个人信息。除法律法规规定的情形外，未经用户许可，我们不会向第三方公开、透露用户个人信息。
          1.2 注册账号需要您提供您的邮箱信息，我们保证不会向此邮箱发送任何推送以及广告信息
          1.3 未经允许，找啥不会向任何公司/组织/个人披露您的个人信息
          1.4 为了您能够上传本地图片以及上传相机拍摄的图片，我们需要您在首次上传图片使允许照相机以及图片使用功能，我们保证不会以任何方式向任何其他对象公布您的照片或者照相机信息

        二.账号使用规范
          2.1 你在使用找啥前需要注册一个找啥账号，此账号的所有权归HarKore Studio所有，您获得此账号使用权
          2.2 用户有责任妥善保管注册信息以及账户密码的安全，用户需要对注册账户以及密码下的行为承担法律责任。用户同意在任何情况下不向他人透露账户及密码信息。当你怀疑他人在使用您的账号时，应该立即通知HarKore Stuido
          2.3 请在进行交易时小心谨慎，HarKore Studio承诺为使用者建立舒适安全的使用环境，但不对任何私人行为负责
        
        三.用户行为规范
          3.1 本条所述信息内容是指用户使用本软件以及服务过程中所制作/复制/发布/传播的任何内容，包括但不限于找啥账号头像/用户说明/名字等注册信息，或文字/图片等发送在您的广告中的内容
          3.2 您理解并同意，找啥致力于为用户提供文明健康，规范有序的网络环境，您不得利用找啥制作/复制/发布/传播如下信息，包括但不限于：
            (1). 发布/传播/传送/储存侵害他人名誉权,肖像权，知识产权，商业秘密等合法权利的内容
            (2). 涉及他人隐私/个人信息或资料的内容
            (3). 发表/传送/传播广告信息，过度营销信息以及垃圾信息，或任何含有性暗示的骚扰信息
            (4). 任何其他违反法律政策以及公共秩序，社会公德的信息
            (5). 虚假的/不实的/隐瞒真相误导他人的
            (6). 诱导其他用户点击链接页面或分享信息的

        四.软件使用规范
          4.1 HarKore Studio严禁您使用本软件关于著作权的信息
          4.2 不允许对本软件进行反向工程/反向编译/反向汇编，或者以其他方式尝试发现本软件的源代码
          
        五.关于举报与屏蔽
          5.1 如若发现任何违反本条约的现象，您可以在联系工作室功能/私信举报功能/广告举报功能中对此用户进行举报
          5.2 HarKore Studio向您保证会在24小时内处理举报信息
          5.3 您可以对用户进行屏蔽，屏蔽后该用户将无法对您发送任何私人信息
        """
        
        let alert=UIAlertController(title:"用户协议",message:xieyi,preferredStyle:.alert)
        let action=UIAlertAction(title:"同意",style:.default,handler:{
            action in
        self.performSegue(withIdentifier: "reg", sender: self)
        })
        
        let cancel=UIAlertAction(title:"拒绝",style:.default,handler:{
            cancel in
            return
        })
        
        alert.addAction(action)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
        
        
    }
    
    
    @IBOutlet weak var logo: UIImageView!
    
    override func viewDidLoad() {

      super.viewDidLoad()
        
        if UIDevice.current.userInterfaceIdiom == .pad{
            logo.isHidden = true
        }
        
        Auth.auth().addStateDidChangeListener {auth, user in
            if user != nil{
                self.performSegue(withIdentifier: "loggedin", sender: self)
            }
            else{
                //user not log in
            }
            
        }
        setupViews()

        let center: NotificationCenter = NotificationCenter.default;
        center.addObserver(self, selector: #selector(keyboardDidShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        center.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func keyboardDidShow(notification: Notification) {
        let info: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardSize = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardY = self.view.frame.size.height - keyboardSize.height
        let editingTextFieldY:CGFloat! = self.passField.frame.origin.y
        
        if editingTextFieldY > keyboardY - 60 {
            UIView.animate(withDuration: 0.25, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                self.view.frame = CGRect(x: 0, y: self.view.frame.origin.y - (editingTextFieldY! - (keyboardY + 10)), width: self.view.bounds.width, height: self.view.bounds.height)
            }, completion: nil)
            
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        UIView.animate(withDuration: 0.25, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        }, completion: nil)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    


    func setupViews() {
        view.addSubview(revealingSplashView)
        
        revealingSplashView.startAnimation()
    }
    
    
    
    let revealingSplashView = RevealingSplashView(iconImage: #imageLiteral(resourceName: "harkore"), iconInitialSize: CGSize(width: 123, height: 123), backgroundColor: UIColor.white)
    
 



    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  

}
