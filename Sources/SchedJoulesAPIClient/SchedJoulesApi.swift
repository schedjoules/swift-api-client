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
        
        //Create URLComponents using the query url to add the updated parameter
        guard var queryURLComponents = URLComponents(url: query.url, resolvingAgainstBaseURL: false) else {
            completion(.failure(ApiError.invalidURL))
            return
        }
        
        //Create the updated parameters for the query avoiding invalid values for a URLQueryItem
        var updatedQueryParameters = updatedParameters.compactMap({ (parameter) -> URLQueryItem? in
            guard let value = parameter.value as? String else {
                return nil
            }
            return URLQueryItem(name: parameter.key, value: value)
        })
        
        //Append the updated parameters to the URLComponents for GET requests
        if query.method == .get {
            let currentQueryItems = queryURLComponents.queryItems ?? []
            updatedQueryParameters.append(contentsOf: currentQueryItems)
            queryURLComponents.queryItems = updatedQueryParameters
        }
        
        //Confirm a valid url can be created from the URLComponents
        guard let updatedURL = queryURLComponents.url else {
            completion(.failure(ApiError.invalidURL))
            return
        }
        
        //Create and start the request
        var request = URLRequest(url: updatedURL)
        
        print("request: ", request)
        
        //Add headers
        request.addValue("Token token=\(accessToken)", forHTTPHeaderField: "Authorization")
        query.headers.forEach { key, value in
            request.addValue(value, forHTTPHeaderField: key)
        }
        
        //Add method and body for POST requests
        if query.method == .post {
            do {
                request.httpMethod = "POST"
                let parametersData = try JSONSerialization.data(withJSONObject: query.parameters, options: .fragmentsAllowed)
                request.httpBody = parametersData
            } catch {
                print("body error: ", error)
            }
        }
        
        
        print("cURL: ", request.cURL)
        
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





public extension URLRequest {

    /// Returns a cURL command for a request
    /// - return A String object that contains cURL command or "" if an URL is not properly initalized.
    var cURL: String {

        guard
            let url = url,
            let httpMethod = httpMethod,
            url.absoluteString.utf8.count > 0
        else {
                return ""
        }

        var curlCommand = "curl --verbose \\\n"

        // URL
        curlCommand = curlCommand.appendingFormat(" '%@' \\\n", url.absoluteString)

        // Method if different from GET
        if "GET" != httpMethod {
            curlCommand = curlCommand.appendingFormat(" -X %@ \\\n", httpMethod)
        }

        // Headers
        let allHeadersFields = allHTTPHeaderFields ?? [String: String]()
        let allHeadersKeys = Array(allHeadersFields.keys)
        let sortedHeadersKeys  = allHeadersKeys.sorted(by: <)
        for key in sortedHeadersKeys {
            curlCommand = curlCommand.appendingFormat(" -H '%@: %@' \\\n", key, self.value(forHTTPHeaderField: key)!)
        }

        // HTTP body
        if let httpBody = httpBody, httpBody.count > 0 {
            let httpBodyString = String(data: httpBody, encoding: String.Encoding.utf8)!
            let escapedHttpBody = URLRequest.escapeAllSingleQuotes(httpBodyString)
            curlCommand = curlCommand.appendingFormat(" --data '%@' \\\n", escapedHttpBody)
        }

        return curlCommand
    }

    /// Escapes all single quotes for shell from a given string.
    static func escapeAllSingleQuotes(_ value: String) -> String {
        return value.replacingOccurrences(of: "'", with: "'\\''")
    }
}
