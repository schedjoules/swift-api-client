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
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testJsonPageItemDecoding() {
        let path = Bundle(for: type(of: self)).path(forResource: "sample_page_item", ofType: "json")
        XCTAssertNotNil(path)
        let data = try? Data(contentsOf: URL(fileURLWithPath: path!), options: .mappedIfSafe)
        XCTAssertNotNil(data)
        
        let decoder = JSONDecoder()
        do {
            let pageItem = try decoder.decode(JSONPageItem.self, from: data!)
            print(pageItem)
        } catch {
            XCTFail()
        }
    }
    
    func testJsonPageSectionDecoding() {
        let path = Bundle(for: type(of: self)).path(forResource: "sample_page_section", ofType: "json")
        XCTAssertNotNil(path)
        let data = try? Data(contentsOf: URL(fileURLWithPath: path!), options: .mappedIfSafe)
        XCTAssertNotNil(data)
        
        let decoder = JSONDecoder()
        do {
            let pageSection = try decoder.decode(JSONPageSection.self, from: data!)
            print(pageSection)
        } catch {
            print(error)
            XCTFail()
        }
    }
    
    func testJsonPageDecoding() {
        let path = Bundle(for: type(of: self)).path(forResource: "sample_page", ofType: "json")
        XCTAssertNotNil(path)
        let data = try? Data(contentsOf: URL(fileURLWithPath: path!), options: .mappedIfSafe)
        XCTAssertNotNil(data)
        
        let decoder = JSONDecoder()
        do {
            let page = try decoder.decode(JSONPage.self, from: data!)
            print(page)
        } catch {
            XCTFail()
        }
        
    }
    
    func testQueryResult() {
        let api = SchedJoulesApiClient(accessToken: getApiKey())
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
    
    func testCalendarQuery() {
        let api = SchedJoulesApiClient(accessToken: getApiKey())
        let responseExpectation = expectation(description: "Received response")
        let icsQuery = CalendarQuery(url: URL(string: "https://iphone.schedjoules.com/calendars/afdd5213056f?l=en&x=6cdd34")!)
        api.execute(query: icsQuery, completion: { result in
            switch result {
            case let .success(calendar):
                responseExpectation.fulfill()
                XCTAssertNotNil(calendar)
            case let .failure(apiError):
                print(apiError)
                XCTFail()
            }
        })
        
        waitForExpectations(timeout: 10.0) { (_) -> Void in }
    }
    
    // Read API Key from API.plist (not included in source control, please create your own using the API Key we provided you with.)
    func getApiKey() -> String {
        let apiInfoPath = Bundle(for: type(of: self)).url(forResource: "API", withExtension: "plist")
        XCTAssertNotNil(apiInfoPath)
        let apiInfoData = try? Data(contentsOf: apiInfoPath!)
        XCTAssertNotNil(apiInfoData)
        let apiPlist = (try? PropertyListSerialization.propertyList(from: apiInfoData!, options: [], format: nil)) as? [String: String]
        XCTAssertNotNil(apiPlist)
        let apiKey = apiPlist!["API_KEY"]
        XCTAssertNotNil(apiKey)
        return apiKey!
    }
    
}
