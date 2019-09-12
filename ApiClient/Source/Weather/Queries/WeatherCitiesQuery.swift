import Foundation
//
//  WeatherCitiesQuery.swift
//  ApiClient
//
//  Created by Alberto Huerdo on 2019. 08. 20..
//  Copyright © 2019 SchedJoules. All rights reserved.
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
import MapKit

public final class WeatherCitiesQuery: Query {
    public typealias Result = [WeatherAnnotation]
    
    public let url: URL
    public let method: HTTPMethod = .get
    public let encoding: ParameterEncoding = URLEncoding.default
    public let parameters: Parameters
    public let headers: HTTPHeaders = ["Accept" : "application/json"]
    
    private init(queryItems: [URLQueryItem]) {
        // Initialize url components from a string
        var urlComponents = URLComponents(string: "https://api.schedjoules.com/cities/cities_within_bounds")
        // Add query items to the url
        urlComponents!.queryItems = queryItems
        // Set the url property to the url constructed from the components
        self.url = urlComponents!.url!
        //For parameters we need to pass an identifier.
        //We first try to use the identifier for vendor to keep the uuid consistent, if we can’t do it we create a random one
        parameters = ["u" : UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString]
    }
    
    /// Automatically add locale and location parameter to the pages URL
    public convenience init(northEastCoordinate: CLLocationCoordinate2D,
                            southWestCoordinate: CLLocationCoordinate2D) {
        self.init(queryItems: [URLQueryItem(name: "ne",
                                            value: "\(northEastCoordinate.latitude),\(northEastCoordinate.longitude)"),
                               URLQueryItem(name: "sw",
                                            value: "\(southWestCoordinate.latitude),\(southWestCoordinate.longitude)")])
    }
    
    public func handleResult(with data: Data) -> [WeatherAnnotation]? {
        do {
            let weatherAnnotation = try JSONDecoder().decode([JSONWeatherAnnotation].self, from: data)
            return weatherAnnotation
        } catch {
            return nil
        }
    }
    
}
