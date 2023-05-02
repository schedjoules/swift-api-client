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
    public let headers: [String : String] = ["Content-Type" : "application/json"]
    
    private init(_ userId: String, expirationDate: Date) {
        self.url = URL(string: "https://api.schedjoules.com/accounts/\(userId)/licenses")!
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let dateString = formatter.string(from: expirationDate)
        
        self.parameters = ["expiration_date": dateString] as! [String : AnyObject]
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
