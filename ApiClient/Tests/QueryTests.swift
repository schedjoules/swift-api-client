//
//  QueryTests.swift
//  QueryTests
//
//  Created by Balazs Vincze on 2018. 03. 19..
//  Copyright © 2018. SchedJoules. All rights reserved.
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

import XCTest
@testable import ApiClient

class QueryTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testHomePageQuery() {
        let api = SchedJoulesApiClient(accessToken: "0443a55244bb2b6224fd48e0416f0d9c")        
        let responseExpectation = expectation(description: "Received response")
        let homePageQuery = HomePageQuery()
        api.execute(query: homePageQuery, completion: { result in
            switch result {
            case let .success(page):
                XCTAssertNotNil(page)
            case let .failure(apiError):
                print(apiError)
                XCTFail()
            }
            responseExpectation.fulfill()
        })

        wait(for: [responseExpectation], timeout: 10.0)
    }
    
    func testSinglePageQuery() {
        let api = SchedJoulesApiClient(accessToken: "0443a55244bb2b6224fd48e0416f0d9c")
        let responseExpectation = expectation(description: "Received response")
        let singlePageQuery = SinglePageQuery(pageID: "115673")
        api.execute(query: singlePageQuery, completion: { result in
            switch result {
            case let .success(page):
                XCTAssertNotNil(page)
            case let .failure(apiError):
                print(apiError)
                XCTFail()
            }
            responseExpectation.fulfill()
        })
        
        wait(for: [responseExpectation], timeout: 10.0)
    }
    
    func testSearchQuery() {
        let api = SchedJoulesApiClient(accessToken: "0443a55244bb2b6224fd48e0416f0d9c")
        let responseExpectation = expectation(description: "Received response")
        let searchQuery = SearchQuery(query: "swim")
        api.execute(query: searchQuery, completion: { result in
            switch result {
            case let .success(page):
                XCTAssertNotNil(page)
            case let .failure(apiError):
                print(apiError)
                XCTFail()
            }
            responseExpectation.fulfill()
        })
        
        wait(for: [responseExpectation], timeout: 10.0)
    }
    
}
