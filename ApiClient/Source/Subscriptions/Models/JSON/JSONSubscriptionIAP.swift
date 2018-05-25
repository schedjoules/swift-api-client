//
//  JSONSubscriptionIAP.swift
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

struct JSONSubscriptionIAP: SubscriptionIAP {
    let productId: String
    let freeTrialStatus: FreeTrialStatus
    let localizedUpgradeButtonText: String
    let localizedPriceInfo: String
}

// MARK: - Decodable protocol
extension JSONSubscriptionIAP: Decodable {
    // JSON keys
    enum PageKeys: String, CodingKey {
        case productId
        case freeTrialStatus
        case localizedUpgradeButtonText
        case localizedPriceInfo
    }
    
    init(from decoder: Decoder) throws {
        // Get data container
        let container = try decoder.container(keyedBy: PageKeys.self)
        
        // Decode required properties
        let productId = try container.decode(String.self, forKey: .productId)
        let freeTrialStatus = try container.decode(FreeTrialStatus.self, forKey: .freeTrialStatus)
        let localizedUpgradeButtonText = try container.decode(String.self, forKey: .localizedUpgradeButtonText)
        let localizedPriceInfo = try container.decode(String.self, forKey: .localizedPriceInfo)
        
        // Initialize with the decoded valuess
        self.init(productId: productId, freeTrialStatus: freeTrialStatus, localizedUpgradeButtonText: localizedUpgradeButtonText, localizedPriceInfo: localizedPriceInfo)
    }
}
