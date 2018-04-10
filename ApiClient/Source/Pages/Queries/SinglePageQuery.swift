//
//  SinglePageQuery.swift
//  ApiClient
//
//  Created by Balazs Vincze on 2017. 12. 18..
//  Copyright © 2017. SchedJoules. All rights reserved.
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
import Alamofire

final class SinglePageQuery: Query {    
    typealias Result = JSONPage
    
    let url: URL
    let host: String = "https://api.schedjoules.com"
    let method: HTTPMethod = .get
    let parameters: Parameters = [:]
    let headers: HTTPHeaders = ["Accept" : "application/json", "Content-Type" : "application/json"]
    
    required init?(path: String?, queryItems: [URLQueryItem]) {
        // Build url from components
        guard var urlComponents = URLComponents(string: host) else {
            return nil
        }
        // Add path to the url
        if path != nil {
            urlComponents.path = "/pages/\(path!)"
        }
        urlComponents.queryItems = queryItems
        // If the url could not be constructed, return nil
        if urlComponents.url == nil {
            return nil
        }
        self.url = urlComponents.url!
    }
    
    /// Initialize with a given Page ID and automatically add locale parameter
    convenience init?(pageID: String) {
        let localeQuery = URLQueryItem(name: "locale", value: Locale.preferredLanguages[0].components(separatedBy: "-")[0])
        self.init(path: pageID, queryItems: [localeQuery])
    }
    
    /// Initialize with a given Page ID and a locale
    convenience init?(pageID: String, locale: String) {
        self.init(path: pageID, queryItems: [URLQueryItem(name: "locale", value: locale)])
    }
    
    /// Return a Page object from the data
    func handleResult(with data: Data) -> JSONPage? {
        return try? JSONDecoder().decode(JSONPage.self, from: data)
    }
}
