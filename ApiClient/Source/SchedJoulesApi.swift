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

public final class SchedJoulesApi: NSObject, Api {
    
    private let accessToken: String
    private let userId: String
    private let apiDomain = ".schedjoules.com"
    
    // Initiliaze with an access token
    public required init (accessToken: String, userId: String) {
        self.accessToken = accessToken
        self.userId = userId
        
        super.init()
    }
    
    // Execute a request object
    public func execute<T>(query: T, completion: @escaping (Result<T.Result, ApiError>) -> Void) where T : Query {
        // Check if the url of the query is in the right domain
        if query.url.host!.suffix(apiDomain.count) != apiDomain {
            DispatchQueue.main.async {
                completion(.failure(ApiError.invalidDomain))
            }
        }
        //Update the parameters to include the userId
        var updatedParameters = query.parameters
        updatedParameters["u"] = userId as AnyObject
        
        var queryURlComponents = URLComponents(string: query.url.absoluteString)!
        let currentQueryItems = queryURlComponents.queryItems ?? []
        
        queryURlComponents.queryItems = currentQueryItems + updatedParameters.map {
            URLQueryItem(name: $0.key, value: String(describing: $0.value))
        }
                
        var request = URLRequest(url: queryURlComponents.url!)
        request.addValue("Token token=\(accessToken)", forHTTPHeaderField: "Authorization")
        
        
        let sessionConfig: URLSessionConfiguration = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: self, delegateQueue: nil)
        
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
            guard error == nil else {
                DispatchQueue.main.async {
                    completion(.failure(ApiError.error(error!, response: nil)))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(ApiError.errorHandlingResult))
                }
                return
            }
            
            guard let handledResult = query.handleResult(with: data) else {
                DispatchQueue.main.async {
                    completion(.failure(ApiError.errorHandlingResult))
                }
                return
            }
            
            DispatchQueue.main.async {
                completion(.success(handledResult))
            }
        })
        
        task.resume()
    }
    
}

extension SchedJoulesApi: URLSessionDelegate, URLSessionTaskDelegate {
    
    public func urlSession(_ session: URLSession,
                           task: URLSessionTask,
                           willPerformHTTPRedirection response: HTTPURLResponse,
                           newRequest request: URLRequest,
                           completionHandler: @escaping (URLRequest?) -> Void) {
        guard let url = request.url else {
            DispatchQueue.main.async {
                completionHandler(request)
            }
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.httpMethod
        urlRequest.setValue("Token token=\(self.accessToken)", forHTTPHeaderField: "Authorization")
        DispatchQueue.main.async {
            completionHandler(urlRequest)
        }
    }
    
}
