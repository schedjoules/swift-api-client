//
//  HomePageQuery.swift
//  ApiClient
//
//  Created by Balazs Vincze on 2017. 12. 18..
//  Copyright © 2017. SchedJoules. All rights reserved.
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
import Alamofire

public final class HomePageQuery: Query {
    public typealias Result = Page

    public let url: URL
    public let method: HTTPMethod = .get
    public let encoding: ParameterEncoding = URLEncoding.default
    public let parameters: Parameters = [:]
    public let headers: HTTPHeaders = ["Accept" : "application/json"]

    private init(queryItems: [URLQueryItem]) {
        // Initialize url components from a string
        var urlComponents = URLComponents(string: "https://api.schedjoules.com/pages")
        // Add query items to the url
        urlComponents!.queryItems = queryItems
        // Set the url property to the url constructed from the components
        self.url = urlComponents!.url!
    }
    
    /// Automatically add locale and location parameter to the pages URL
    public convenience init() {
        print("locale 1: ", Locale.preferredLanguages)
        print("locale 2: ", Locale.preferredLanguages[0])
        print("locale 3: ", Locale.preferredLanguages[0].components(separatedBy: "-"))
        print("locale 4: ", Locale.preferredLanguages[0].components(separatedBy: "-")[0])
        print("locale 5: ", Locale.current)
        print("locale 6: ", Locale.current.regionCode)
        print("locale 6: ", Locale.current.identifier)
        print("locale 7: ", Locale.isoRegionCodes)
        self.init(locale: Locale.preferredLanguages[0].components(separatedBy: "-")[0],
                  location: Locale.current.regionCode!)
    }
    
    /// Manualy specify locale and location parameters
    public convenience init(locale: String, location: String) {
        self.init(queryItems: [URLQueryItem(name: "locale", value: locale),
                               URLQueryItem(name: "location", value: location)])
    }
    
    /// Return a Page object from the data
    public func handleResult(with data: Data) -> Page? {
        return try? JSONDecoder().decode(JSONPage.self, from: data)
    }
}
