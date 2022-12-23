//
//  LicenseStatus.swift
//  ApiClient
//
//  Created by Alberto on 23/12/22.
//  Copyright © 2022 SchedJoules. All rights reserved.
//

import Foundation

public struct LicenseStatus: Decodable {
    
    struct License: Decodable {
        let expirationDate: String?
        let licenseId: String?
    }
    
    let accountId: String?
    let licenses: [License]
    
    var currentExpirationDate: Date? {
        guard licenses.count > 0 else {
            return nil
        }
        
        //return date furthest in the future for the current BundleID
        return Date()
    }
}
