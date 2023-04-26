//
//  CalendarQuery.swift
//  ApiClient
//
//  Created by Balazs Vincze on 2018. 03. 21..
//  Copyright © 2018. SchedJoules. All rights reserved.
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

public final class CalendarQuery: Query {
    public typealias Result = ICalendar

    public let url: URL
    public let method: SJHTTPMethod = .get
//    public let encoding: ParameterEncoding = URLEncoding.default
    public let parameters: [String : AnyObject] = [:]
    public let headers: [String : String] = ["Accept" : "application/json"]
    
    public required init(url: URL) {
        self.url = url
    }
    
    /// Parse the retrieved .ics file
    public func handleResult(with data: Data) -> ICalendar? {
        guard let icsString = String(data: data, encoding: .utf8) else {
            return nil
        }
        return Parser.parse(ics: icsString)
    }

}
