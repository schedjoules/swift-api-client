//
//  JSONSubscription.swift
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

struct JSONSubscription: Subscription {
    let subscriptionId: String
    let expirationDate: TimeInterval
    let purchaseDate: TimeInterval
    let subscriptionStatusCode: Int
    let subscriptionStatusMessage: String
    let transactionIds: [UInt64]
}

// MARK: - Decodable protocol
extension JSONSubscription: Decodable {
    // JSON keys
    enum PageKeys: String, CodingKey {
        case subscriptionId
        case expirationDate
        case purchaseDate
        case subscriptionStatusCode
        case subscriptionStatusMessage
        case transactionIds
    }
    
    init(from decoder: Decoder) throws {
        // Get data container
        let container = try decoder.container(keyedBy: PageKeys.self)
        
        // Decode required properties
        let subscriptionId = try container.decode(String.self, forKey: .subscriptionId)
        let expirationDate = try container.decode(TimeInterval.self, forKey: .expirationDate)
        let purchaseDate = try container.decode(TimeInterval.self, forKey: .purchaseDate)
        let subscriptionStatusCode = try container.decode(Int.self, forKey: .subscriptionStatusCode)
        let subscriptionStatusMessage = try container.decode(String.self, forKey: .subscriptionStatusMessage)
        let transactionIds = try container.decode([UInt64].self, forKey: .transactionIds)
        
        // Initialize with the decoded valuess
        self.init(subscriptionId: subscriptionId, expirationDate: expirationDate, purchaseDate: purchaseDate, subscriptionStatusCode: subscriptionStatusCode, subscriptionStatusMessage: subscriptionStatusMessage, transactionIds: transactionIds)
    }
}
