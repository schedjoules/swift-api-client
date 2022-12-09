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
    public let method: SJHTTPMethod = .post
//    public let encoding: ParameterEncoding = URLEncoding.default
    public let parameters: [String : AnyObject] = [:]
    public let headers: [String : String] = ["Accept" : "application/json"]
    
    private init(_ accountId: String) {
        self.url = URL(string: "https://api.schedjoules.com/accounts/\(accountId)/licenses")!
    }
    
    /// Initialize with the number of items to return
    public convenience init(accountId: String) {
        self.init(accountId)
    }
    
    /// Return a Page object from the data
    public func handleResult(with data: Data) -> LicenseStatus? {
        do {
            let json = try JSONSerialization.jsonObject(with: data)
            print("json: ", json)
            
            
            if let dict = json as? [String: AnyObject] {
                print("dict: ", dict)
                dict.keys.forEach { key in
                    print("key: ", key)
                    print("value: ", dict[key])
                    
                    if key == "licenses" {
                        if let licences = dict["licenses"] as? [AnyObject] {
                            if let first = licences.first as? [String: AnyObject] {
                                print("first a: ", first.keys)
                            }
                        }
                    }
                }
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            let value = try decoder.decode(LicenseStatus.self, from: data)
            return value
        } catch {
            print("error: ", error)
            return nil
        }
    }
    
}


public struct LicenseStatus: Decodable {
//    let apiKey: String
//    let appName: String
//    let pricingModel: Int
//    let remarks: String
//    let status: String
//    let subDomain: String
//    let uniqueId: String
//    let user: String
//    let yourAcceptHeader: String
    
    struct License: Decodable {
        struct Expiration: Decodable {
            let expirationDate: Date
        }
        
        let expiration: Expiration
    }
    
    let accountId: String
    var licenses: [License] {
        let expiration = License.Expiration(expirationDate: Calendar.current.date(byAdding: .day, value: 10, to: Date())!)
        let license = License(expiration: expiration)
        return [license]
    }
    
    /*
     
     let api_key: String
     let app_name: String
     let pricing_model: Int
     let remarks: String
     let status: String
     let sub_domain: String
     let unique_id: String
     let user: String
     let your_accept_header: String
     */
}
