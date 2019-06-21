//
//  ViewController.swift
//  Purchases App
//
//  Created by Saliou DJALO on 18/06/2019.
//  Copyright © 2019 Saliou DJALO. All rights reserved.
//

import UIKit
import StoreKit // for add in app purchases

class ViewController: UIViewController, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    @IBOutlet weak var lollipopImageView: UIImageView!
    @IBOutlet weak var priceResultLabel: UILabel!
    
    var activeProduct:SKProduct?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // track status on payment
        // dont forget SKPaymentTransactionObserver
        SKPaymentQueue.default().add(self)
        
        
        // Do any additional setup after loading the view.
        let tap = UITapGestureRecognizer(target: self, action: #selector(buyItem))
        lollipopImageView.addGestureRecognizer(tap)
        lollipopImageView.isUserInteractionEnabled = true // autoriser l'interaction
        
        // whats product the guy want to buy
        
        // what is Set
        /*
         Sets is simply a container that can hold multiple value of data type in an unordered list and ensures unique element in the container (i.e each data appears only once).
         */
        
        let productIds : Set<String> = ["com.djalo.PurchasesApp.lollipop"] // id available on itunes connect then features
        let prodReq = SKProductsRequest(productIdentifiers: productIds) // lets make a product request
        prodReq.delegate = self
        prodReq.start()
        
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        for transaction in transactions {
            switch (transaction.transactionState) {
            case .purchased:
                print("Transaction complete !")
                SKPaymentQueue.default().finishTransaction(transaction)
                priceResultLabel.text = "Item bought ! Thanks."
                priceResultLabel.textColor = UIColor.blue
            case .failed:
                print("Transaction failed !")
                SKPaymentQueue.default().finishTransaction(transaction)
                priceResultLabel.text = "Transaction failed ! Try again"
                priceResultLabel.textColor = UIColor.red
            default:
                break
            }
        }
        
    }
    
    // SKProductsRequestDelegate functions
    // trought this function, I can get products details
    // its works only if you have fill all the details in link with the Agreement, Tax, Bax Account on Itunes Connect
    // Paid Application
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print("Loaded Products")
        
        if response.products.count == 0 {
            print("No products available !")
        }
        
        for product in response.products {
            print("Product : \(product.productIdentifier) - \(product.localizedTitle) - \(product.localizedDescription) - \(product.price.floatValue)")
            activeProduct = product
            
        }
        
    }
    
    
    @objc func buyItem() {
        print("Lollipop tapped !")
        guard let activeProd = activeProduct else { return }
        print("Purchasing in progress")
        let payment = SKPayment(product: activeProd)
        SKPaymentQueue.default().add(payment)
        
    }
    
}

