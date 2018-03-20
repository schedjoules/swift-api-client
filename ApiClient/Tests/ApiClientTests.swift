//
//  ApiClientTests.swift
//  ApiClientTests
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

class ApiClientTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testJsonPageItemDecoding() {
        let testBundle = Bundle(for: type(of: self))
        guard let path = testBundle.path(forResource: "sample_page_item", ofType: "json") else {
            XCTFail()
            return
        }
        
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe) else {
            XCTFail()
            return
        }
        
        let decoder = JSONDecoder()
        do {
            let pageItem = try decoder.decode(JSONPageItem.self, from: data)
            print(pageItem)
        } catch {
            print(error)
            XCTFail()
        }
    }
    
    func testJsonPageSectionDecoding() {
        let testBundle = Bundle(for: type(of: self))
        guard let path = testBundle.path(forResource: "sample_page_section", ofType: "json") else {
            XCTFail()
            return
        }
        
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe) else {
            XCTFail()
            return
        }
        
        let decoder = JSONDecoder()
        do {
            let pageSection = try decoder.decode(JSONPageSection.self, from: data)
            print(pageSection)
        } catch {
            print(error)
            XCTFail()
        }
    }
    
    func testJsonPageDecoding() {
        let testBundle = Bundle(for: type(of: self))
        guard let path = testBundle.path(forResource: "sample_page", ofType: "json") else {
            XCTFail()
            return
        }
        
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe) else {
            XCTFail()
            return
        }
        
        let decoder = JSONDecoder()
        do {
            let page = try decoder.decode(JSONPage.self, from: data)
            print(page)
        } catch {
            print(error)
            XCTFail()
        }
    }
    
    func testQueryResult() {
        let api = SchedJoulesApiClient(accessToken: "0443a55244bb2b6224fd48e0416f0d9c")        
        let responseExpectation = expectation(description: "Received response")
        api.execute(query: HomePageQuery(), completion: { result in
            switch result {
            case let .success(page):
                responseExpectation.fulfill()
                XCTAssertNotNil(page)
            case let .failure(apiError):
                print(apiError)
                XCTFail()
            }
        })
        
        waitForExpectations(timeout: 10.0) { (_) -> Void in }
    }
    
}
