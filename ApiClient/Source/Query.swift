//
//  Query.swift
//  ApiClient
//
//  Created by Balazs Vincze on 2017. 12. 15..
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

public protocol Query {
    /// The type returned by the query.
    associatedtype Result
    
    /// The URL of the query which must be in the `.schedjoules.com` domain.
    var url: URL { get }
    
    /**
     The HTTP method type of the query.
     
     **See:**
     [HTTP method types](https://tools.ietf.org/html/rfc7231#section-4.3)
     */
    var method: HTTPMethod { get }
    
    /**
     The parameters are key-value pairs to append to the request. Used mostly for `POST` requests.
     
     **Example:**
     ````
     ["username" : "user", "password" : "pass"]
     ````
     */
    var parameters: Parameters { get }
    
    /**
     The HTTP headers for the query.
     
     **Example:**
     ````
     ["Accept" : "application/json"]
     ````
     */
    var headers: HTTPHeaders { get }
    
    /**
     Specifies how the query parameters should be encoded.
     
    **See:**
     [Alamofire ParameterEncoding](https://github.com/Alamofire/Alamofire/blob/master/Source/ParameterEncoding.swift)
     */
    var encoding: ParameterEncoding { get }
    
    /// Turn the response from the API into the associated type.
    func handleResult(with data: Data) -> Result?
}
