//
//  API.swift
//  ApiClient
//
//  Created by Balazs Vincze on 2017. 12. 15..
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
import enum Result.Result

final class SchedJoulesApiClient: Api {
    private let accessToken: String
    private let sessionManager: Alamofire.SessionManager
    
    // Initiliaze with an access token
    required init (accessToken: String) {
        self.accessToken = accessToken
        
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
    func execute<T: Query> (query: T, completion: @escaping (Result<T.Result,ApiError>) -> Void) {
        // Check if url is not nil
        guard let url = query.url else {
            completion(.failure(ApiError.emptyURL))
            return
        }
        
        // Set required HTTP headers
        var headers = Alamofire.SessionManager.defaultHTTPHeaders
        headers["Authorization"] = "Token token=\(accessToken)"
        
        // Add headers from request object
        for (key,value) in query.headers {
            headers[key] = value
        }
        
        // Execute the request
        sessionManager.request(url, method: query.method, parameters: query.parameters, encoding: URLEncoding.default, headers: headers).validate().responseData { response in
            switch response.result {
            case .success:
                guard let responseData = response.result.value else {
                    print("Response data is nil.")
                    completion(.failure(ApiError.emptyResponseData))
                    return
                }
                completion(.success(query.handleResult(with: responseData)))
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
