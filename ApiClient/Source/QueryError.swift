//
//  QueryError.swift
//  ApiClient
//
//  Created by Balazs Vincze on 2018. 04. 11..
//  Copyright © 2018. SchedJoules. All rights reserved.
//

import Foundation

enum QueryError: Error {
    case invalidHost
    case emptyURL
}
