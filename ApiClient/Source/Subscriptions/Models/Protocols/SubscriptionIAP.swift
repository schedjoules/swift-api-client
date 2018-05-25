//
//  SubscriptionIAP.swift
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

/// Possible statuses of the free trial.
public enum FreeTrialStatus: String, Decodable {
    case available
    case unavailable
    
}

public protocol SubscriptionIAP {
    /// The identifier of the IAP.
    var productId: String { get }
    /// Indicates whether the free trial is available or not.
    var freeTrialStatus: FreeTrialStatus { get }
    /// Localized text for the subscribe button
    var localizedUpgradeButtonText: String { get }
    /// Localized extra information regarding the pricing.
    var localizedPriceInfo: String { get }
}
