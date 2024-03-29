//
//  RecommendationsQuery.swift
//  ApiClient
//
//  Created by Alberto on 15/07/22.
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

public final class RecommendationsQuery: Query {
    public typealias Result = Page
    
    public let url: URL
    public let method: SJHTTPMethod = .get
//    public let encoding: ParameterEncoding = URLEncoding.default
    public let parameters: [String : AnyObject] = [:]
    public let headers: [String : String] = ["Accept" : "application/json"]
    
    private init(queryItems: [URLQueryItem]) {
        var urlComponents = URLComponents(string: "https://api.schedjoules.com/pages")
        // Add query items to the url
        urlComponents!.queryItems = queryItems
        // Set the url property to the url constructed from the components
        self.url = urlComponents!.url!
    }
    
    /// Initialize with the number of items to return
    public convenience init(numberOfItems: Int) {
        self.init(queryItems: [URLQueryItem(name: "top", value: String(numberOfItems))])
    }

    /// Initialize with the number of items to return, locale and location parameters
    public convenience init(numberOfItems: Int, locale: String, location: String) {
        self.init(queryItems: [URLQueryItem(name: "recommended", value: String(numberOfItems)),
                               URLQueryItem(name: "locale", value: locale),
                               URLQueryItem(name: "location", value: location)])
    }
    
    /// Return a Page object from the data
    public func handleResult(with data: Data) -> Page? {
        do {
            let value = try JSONDecoder().decode(JSONPage.self, from: data)
            return value
        } catch {
            print("json error: ", error)
            return nil
        }
    }
    
}
