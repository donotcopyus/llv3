//
//  donationVC.swift
//  llv2
//
//  Created by Luna Cao on 2018/9/12.
//  Copyright © 2018年 Luna Cao. All rights reserved.
//

import UIKit
import StoreKit

class donationVC: UIViewController,SKProductsRequestDelegate,SKPaymentTransactionObserver {
    
    
    @IBAction func small(_ sender: Any) {
        
        if SKPaymentQueue.canMakePayments(){
            requestProductInfo("supportSmall")
        }
        else{
            let alert = UIAlertController(title: self.title, message: "付款出错", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "返回重试", style: .default, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            } ))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func middle(_ sender: Any) {
        
        if SKPaymentQueue.canMakePayments(){
            requestProductInfo("supportMedium")
        }
        else{
            let alert = UIAlertController(title: self.title, message: "付款出错", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "返回重试", style: .default, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            } ))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    
    @IBOutlet weak var big: UIButton!
    
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {

        
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        for transaction in transactions{
            switch(transaction.transactionState){
            case .purchasing:
                transactionPurchasing(transaction)
            case .purchased:
                transactionPurchased(transaction)
            case .failed:
                transactionFailed(transaction)
            case .restored:
                return
            case .deferred:
                return
            }
        }
        
    }
    
    fileprivate func requestProductInfo (_ productId: String){
        let identifiers: Set<String> = [productId]
        let request = SKProductsRequest(productIdentifiers: identifiers)
        
        request.delegate = self
        request.start()
    }
    
    fileprivate func transactionPurchasing(_ transaction: SKPaymentTransaction){
        //交易中
    }
    
    fileprivate func transactionPurchased(_ transaction:SKPaymentTransaction){
        
        if let receiptUrl = Bundle.main.appStoreReceiptURL{
            let receipt = NSData(contentsOf: receiptUrl)
            let receiptStr = receipt?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
            DispatchQueue.main.asyncAfter(deadline: DispatchTime(uptimeNanoseconds: 3)){
                print("receiptStr:\(String(describing:receiptStr))")
                print("applicationUsername:\(String(describing:transaction.payment.applicationUsername))")
                SKPaymentQueue.default().finishTransaction(transaction)
            }
        }
        
    }
    
    fileprivate func transactionFailed(_ transacation: SKPaymentTransaction){
        let alert = UIAlertController(title: self.title, message: "付款出错", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "返回重试", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        } ))
        
        self.present(alert, animated: true, completion: nil)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        SKPaymentQueue.default().add(self as SKPaymentTransactionObserver)
    }

    deinit{
        SKPaymentQueue.default().remove(self as SKPaymentTransactionObserver)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

 
    @IBAction func click(_ sender: UIButton) {
        
        if SKPaymentQueue.canMakePayments(){
           requestProductInfo("supportLarge")
        }
        else{
            let alert = UIAlertController(title: self.title, message: "付款出错", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "返回重试", style: .default, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            } ))
            self.present(alert, animated: true, completion: nil)
        }
        
    }

}
