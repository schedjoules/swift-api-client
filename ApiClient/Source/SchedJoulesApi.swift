//
//  SchedJoulesApi.swift
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
import enum Result.Result

public final class SchedJoulesApi: Api {
    private let accessToken: String
    private let userId: String
    private let sessionManager: Alamofire.SessionManager
    private let apiDomain = ".schedjoules.com"
    
    // Initiliaze with an access token
    public required init (accessToken: String, userId: String) {
        self.accessToken = accessToken
        self.userId = userId
        
        // Set up a session manager
        let configuration = URLSessionConfiguration.default
        sessionManager = Alamofire.SessionManager(configuration: configuration)
        
        // Make sure "Authorization" header is preserved between redirects (iOS drops it by default)
        sessionManager.delegate.taskWillPerformHTTPRedirection = { session, task, response, request in
            var mutableRequest = request
            mutableRequest.setValue("Token token=\(self.accessToken)", forHTTPHeaderField: "Authorization")
            return mutableRequest
        }
    }
    
    // Execute a request object
    public func execute<T: Query> (query: T, completion: @escaping (Result<T.Result,ApiError>) -> Void) {
        // Check if the url of the query is in the right domain
        if query.url.host!.suffix(apiDomain.count) != apiDomain {
            completion(.failure(ApiError.invalidDomain))
        }
        
        // Set required HTTP headers
        var headers = Alamofire.SessionManager.defaultHTTPHeaders
        headers["Authorization"] = "Token token=\(accessToken)"
        
        // Add headers from request object
        for (key,value) in query.headers {
            headers[key] = value
        }
        
        //Update the parameters to include the userId
        var updatedParameters = query.parameters
        updatedParameters["u"] = userId
        
        // Execute the request
        sessionManager.request(query.url, method: query.method, parameters: updatedParameters, encoding: query.encoding, headers: headers).validate().responseData { response in
            switch response.result {
            case .success:
                guard let responseData = response.result.value else {
                    completion(.failure(ApiError.emptyResponseData))
                    return
                }
                guard let handledResult = query.handleResult(with: responseData) else {
                    completion(.failure(ApiError.errorHandlingResult))
                    return
                }
                completion(.success(handledResult))
            case .failure(let error):
                guard let data = response.data else {
                    completion(.failure(ApiError.error(error, response: nil)))
                    return
                }
                guard let stringResponse = String(data: data, encoding: .utf8) else {
                    completion(.failure(ApiError.error(error, response: nil)))
                    return
                }
                completion(.failure(ApiError.error(error, response: stringResponse)))
            }
        }
    }
}
