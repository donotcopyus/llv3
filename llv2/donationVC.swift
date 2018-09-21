//
//  donationVC.swift
//  llv2
//
//  Created by Luna Cao on 2018/9/12.
//  Copyright © 2018年 Luna Cao. All rights reserved.
//

import UIKit
import StoreKit

enum IAPHandlerAlertType{
    case disabled
    case restored
    case purchased
    
    //https://hackernoon.com/swift-how-to-add-in-app-purchases-in-your-ios-app-c1dc2fc82319
    
    func message() -> String{
        switch self{
        case .disabled: return "Purchases are disabled in your device!"
        case .restored: return "You've successfully restored your purchase!"
        case .purchased: return "You've successfully bought this purchase!"
        
        }
    }
}

class IAPHandler: NSObject{
    static let shared = IAPHandler()
    
    let SMALLID = "supportSmall"
    let MEDIUMID = "supportMedium"
    let LARGEID = "supportLarge"
    
    fileprivate var productID = ""
    fileprivate var productRequest = SKProductsRequest()
    fileprivate var iapProducts = [SKProduct]()
    
    var purchaseStatusBlock: ((IAPHandlerAlertType) -> Void)?
    
    func canMakePurchase() -> Bool{
        return SKPaymentQueue.canMakePayments()
    }
    
    func purchaseMyProduct(index: Int){
        if iapProducts.count == 0{
            return
        }
        
        if self.canMakePurchase(){
            let product = iapProducts[index]
            let payment = SKPayment(product:product)
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().add(payment)
            
            productID = product.productIdentifier
        }else{
            purchaseStatusBlock?(.disabled)
        }
    }
    
    func restorePurchase(){
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    func fetchAvailableProducts(){
        let productIdentifiers = NSSet(objects: SMALLID,MEDIUMID,LARGEID)
        
        let productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers as! Set<String>)
        productsRequest.delegate = self
        productsRequest.start()
    }
    }

extension IAPHandler:SKProductsRequestDelegate,SKPaymentTransactionObserver{
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if (response.products.count > 0) {
            iapProducts = response.products
            for product in iapProducts{
                let numberFormatter = NumberFormatter()
                numberFormatter.formatterBehavior = .behavior10_4
                numberFormatter.numberStyle = .currency
                numberFormatter.locale = product.priceLocale
                let price1Str = numberFormatter.string(from: product.price)
                print(product.localizedDescription + "\nfor just \(price1Str!)")
            }
        }
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        purchaseStatusBlock?(.restored)
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction:AnyObject in transactions {
            if let trans = transaction as? SKPaymentTransaction {
                switch trans.transactionState {
                case .purchased:
                    print("purchased")
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    purchaseStatusBlock?(.purchased)
                    break
                    
                case .failed:
                    print("failed")
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    break
                case .restored:
                    print("restored")
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    break
                    
                default: break
                }}}
    }
    
    
    
}


class donationVC: UIViewController{
    
  
    @IBAction func small(_ sender: Any) {
      
        IAPHandler.shared.purchaseMyProduct(index: 0)
      
    }
    
    @IBAction func middle(_ sender: Any) {
        
     IAPHandler.shared.purchaseMyProduct(index: 1)
        
    }
    
    
    @IBOutlet weak var big: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

       IAPHandler.shared.fetchAvailableProducts()
        IAPHandler.shared.purchaseStatusBlock = {
            [weak self] (type) in
            guard let strongSelf = self else{
                return
            }
            
            if type == .purchased{
                let alertView = UIAlertController(title:"",message: type.message(),preferredStyle:.alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: { (alert) in
                    
                })
                alertView.addAction(action)
                strongSelf.present(alertView, animated: true, completion: nil)
            
            }
        }
      
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

 
    @IBAction func click(_ sender: UIButton) {
       IAPHandler.shared.purchaseMyProduct(index: 2)
    }
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}


