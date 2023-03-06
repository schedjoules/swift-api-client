//
//  LicenseQuery.swift
//  ApiClient
//
//  Created by Alberto on 25/11/22.
//  Copyright © 2022 SchedJoules. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import Foundation

public final class LicenseQuery: Query {
    public typealias Result = LicenseStatus
    
    public let url: URL
    public let method: SJHTTPMethod = .get
    public var parameters: [String : AnyObject] = [:]
    public let headers: [String : String] = ["Accept" : "application/json"]
    
    private init(_ userId: String, expirationDate: Date) {
        self.url = URL(string: "https://api.schedjoules.com/accounts/\(userId)/licenses")!
        
        self.parameters = ["expiration_date": Int(expirationDate.timeIntervalSince1970)] as! [String : AnyObject]
        if let bundle = Bundle.main.bundleIdentifier {
            self.parameters["product_id"] = bundle as AnyObject
        }
    }
    
    /// Initialize with the number of items to return
    public convenience init(userId: String, expirationDate: Date) {
        self.init(userId, expirationDate: expirationDate)
    }
    
    /// Return a Page object from the data
    public func handleResult(with data: Data) -> LicenseStatus? {
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            let json = try JSONSerialization.jsonObject(with: data)
            print("json: ", json)
            
            
            let value = try decoder.decode(LicenseStatus.self, from: data)
            return value
        } catch {
            print("error: ", error)
            return nil
        }
    }
    
}
