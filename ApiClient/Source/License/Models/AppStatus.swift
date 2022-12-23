//
//  AppStatus.swift
//  ApiClient
//
//  Created by Alberto on 23/12/22.
//  Copyright © 2022 SchedJoules. All rights reserved.
//

import Foundation

public struct AppsStatus: Decodable {
    let apiKey: String
    let appName: String
    let pricingModel: Int
    let remarks: String
    let status: String
    let subDomain: String
    let uniqueId: String
    let user: String
    let yourAcceptHeader: String
}
