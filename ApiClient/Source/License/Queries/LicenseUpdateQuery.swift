//
//  LicenseUpdateQuery.swift
//  ApiClient
//
//  Created by Alberto on 23/12/22.
//  Copyright © 2022 SchedJoules. All rights reserved.
//

import Foundation

public final class LicenseUpdateQuery: Query {
    public typealias Result = LicenseStatus
    
    public let url: URL
    public let method: SJHTTPMethod = .post
    public var parameters: [String : AnyObject] = [:]
    public let headers: [String : String] = ["Accept" : "application/json"]
    
    private init(_ userId: String, expirationDate: Date) {
        self.url = URL(string: "https://api.schedjoules.com/accounts/\(userId)/licenses")!
        self.parameters = ["product_id" : "com.schedjoules.ApiClient",
                           "expiration_date": Int(expirationDate.timeIntervalSince1970)] as! [String : AnyObject]
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
            
            let value = try decoder.decode(LicenseStatus.self, from: data)
            return value
        } catch {
            print("error: ", error)
            return nil
        }
    }
    
}
