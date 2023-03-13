//
//  SubscriptionQuery.swift
//  ApiClient
//
//  Created by Balazs Vincze on 2018. 05. 11..
//  Copyright © 2018. SchedJoules. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation
import StoreKit

public final class SubscriptionQuery: Query {
    
    public typealias Result = Subscription
    
    public let url: URL = URL(string:"https://api.schedjoules.com/subscription")!
    public let method: SJHTTPMethod = .post
    public let parameters: [String : AnyObject]
    public let headers: [String : String] = ["Content-Type" : "application/json",
                                       "x-app-id" : Bundle.main.bundleIdentifier ?? "",
                                       "x-user-id" : UIDevice.current.identifierForVendor?.uuidString ?? "",
                                       "x-locale" : Locale.current.regionCode ?? ""]
    
    
    public init(transaction: SKPaymentTransaction, product: SKProduct, receipt: String) {
        let transactionId = transaction.transactionIdentifier ?? ""
        let originalTransactionId = transaction.original?.transactionIdentifier ?? ""
        let purchaseDateValid = transaction.transactionDate ?? Date()
        let purchaseDate = Int(purchaseDateValid.timeIntervalSince1970)
        let productId = product.productIdentifier
        let pricingLocale = product.priceLocale.currencyCode ?? "$" //=> {"type" => "string", "minLength" => 1, "maxLength" => 3},
        let pricing = product.price.description(withLocale: nil) // => {"type" => "string", "minLength" => 1, "maxLength" => 200},
        let formattedPrice = product.localizedDescription
        
        let transactionDictionary = [
            "transactionId" : transactionId,
            "purchaseDate" : purchaseDate,
            "productId" : productId,
            "quantity" : 1,
            "pricingLocale" : pricingLocale,
            "pricing" : pricing,
            "formattedPrice" : formattedPrice,
            "originalTransactionId" : originalTransactionId
            ] as [String : AnyObject]
        
        let requestContents = [
            "transactions": [transactionDictionary],
            "receipt" : receipt
        ] as [String : AnyObject]
        
        self.parameters = requestContents
    }
    
    public func handleResult(with data: Data) -> Subscription? {
        do {
            let json = try JSONDecoder().decode(JSONSubscription.self, from: data)
            return json
        } catch {
            print("error: ", error)
            return nil
        }
    }
}
