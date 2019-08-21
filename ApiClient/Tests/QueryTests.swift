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
import StoreKit
import MapKit
@testable import ApiClient

class QueryTests: XCTestCase {
    
    // Initialize the Api Client
    let api = SchedJoulesApi(accessToken: "0443a55244bb2b6224fd48e0416f0d9c")
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testHomePageQuery() {
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
    
    func testLanguageQuery() {
        let responseExpectation = expectation(description: "Received response")
        let languageQuery = SupportedLanguagesQuery()
        api.execute(query: languageQuery, completion: { result in
            switch result {
            case let .success(languages):
                XCTAssertEqual(languages.count, 18)
            case let .failure(apiError):
                print(apiError)
                XCTFail()
            }
            responseExpectation.fulfill()
        })
        
        waitForExpectations(timeout: 10.0) { (_) -> Void in }
    }
    
    func testCountryQuery() {
        let responseExpectation = expectation(description: "Received response")
        let countryQuery = SupportedCountriesQuery()
        api.execute(query: countryQuery, completion: { result in
            switch result {
            case let .success(countries):
                XCTAssertEqual(countries.count, 74)
            case let .failure(apiError):
                print(apiError)
                XCTFail()
            }
            responseExpectation.fulfill()
        })
        
        waitForExpectations(timeout: 10.0) { (_) -> Void in }
    }
    
    func testTopPageQuery() {
        let responseExpectation = expectation(description: "Received response")
        let topPageQuery = TopPageQuery(numberOfItems: 15, locale: "en", location: "nl")
        api.execute(query: topPageQuery, completion: { result in
            switch result {
            case let .success(page):
                XCTAssertNotNil(page)
            case let .failure(apiError):
                print(apiError)
                XCTFail()
            }
            responseExpectation.fulfill()
        })
        
        waitForExpectations(timeout: 10.0) { (_) -> Void in }
    }
    
    func testNextPageQuery() {
        let responseExpectation = expectation(description: "Received response")
        let nextPageQuery = NextPageQuery(numberOfItems: 15, locale: "en")
        api.execute(query: nextPageQuery, completion: { result in
            switch result {
            case let .success(page):
                XCTAssertNotNil(page)
            case let .failure(apiError):
                print(apiError)
                XCTFail()
            }
            responseExpectation.fulfill()
        })
        
        waitForExpectations(timeout: 10.0) { (_) -> Void in }
    }
    
    func testNewPageQuery() {
        let responseExpectation = expectation(description: "Received response")
        let newPageQuery = NewPageQuery(numberOfItems: 15, locale: "en")
        api.execute(query: newPageQuery, completion: { result in
            switch result {
            case let .success(page):
                XCTAssertNotNil(page)
            case let .failure(apiError):
                print(apiError)
                XCTFail()
            }
            responseExpectation.fulfill()
        })
        
        waitForExpectations(timeout: 10.0) { (_) -> Void in }
    }
    
    func testSubscriptionStatusQuery() {
        let responseExpectation = expectation(description: "Received response")
        let subscriptionStatusQuery = SubscriptionStatusQuery(subscriptionId: "2c520c23cbdda678d7aac86364fbac9d")
        api.execute(query: subscriptionStatusQuery, completion: { result in
            switch result {
            case let .success(subscription):
                XCTAssertNotNil(subscription)
            case let .failure(apiError):
                print(apiError)
                XCTFail()
            }
            responseExpectation.fulfill()
        })
        
        waitForExpectations(timeout: 10.0) { (_) -> Void in }
    }
    
    func testSubscriptionIAPQuery() {
        let responseExpectation = expectation(description: "Received response")
        let subscriptionIAPQuery = SubscriptionIAPQuery()
        api.execute(query: subscriptionIAPQuery, completion: { result in
            switch result {
            case let .success(subscriptionIAP):
                XCTAssertNotNil(subscriptionIAP)
            case let .failure(apiError):
                print(apiError)
                XCTFail()
            }
            responseExpectation.fulfill()
        })
        
        waitForExpectations(timeout: 10.0) { (_) -> Void in }
    }
    
    func testSubscriptionQuery() {
        let responseExpectation = expectation(description: "Received response")
        let subscriptionQuery = SubscriptionQuery(transaction: SKPaymentTransaction(transactionIdentifier: "1000000179103672",
                                                                                    transactionState: .purchased, transactionDate: Date()),
                                                  product: SKProduct(productIdentifier: "com.schedjoules.subscription.ios.50f79da41196.20160324T124400Z.1",
                                                                     price: NSDecimalNumber(value: 0.99),
                                                                     priceLocale: Locale.current),
                                                  receipt: "base64-encoded-receipt-goes-here")
        api.execute(query: subscriptionQuery, completion: { result in
            switch result {
            case let .success(subscription):
                XCTAssertNotNil(subscription)
            case let .failure(apiError):
                print(apiError)
                XCTFail()
            }
            responseExpectation.fulfill()
        })
        
        waitForExpectations(timeout: 10.0) { (_) -> Void in }
    }
    
    func testWeatherSettingsQuery() {
        let responseExpectation = expectation(description: "Received response")
        let query = WeatherSettingsQuery()
        api.execute(query: query, completion: { result in
            switch result {
            case let .success(value):
                XCTAssertNotNil(value)
            case let .failure(apiError):
                print(apiError)
                XCTFail()
            }
            responseExpectation.fulfill()
        })
        
        wait(for: [responseExpectation], timeout: 10.0)
    }
    
    func testWeatherCitiesQuery() {
        let responseExpectation = expectation(description: "Received response")
        
        let northEastCoordinate = CLLocationCoordinate2D(latitude: 62.02379606635583,
                                                         longitude: 19.032229477283522)
        let southWestCoordinate = CLLocationCoordinate2D(latitude: 33.88639350914788,
                                                         longitude: -6.462703718952866)
        
        let query = WeatherCitiesQuery(northEastCoordinate: northEastCoordinate,
                                       southWestCoordinate: southWestCoordinate)
        api.execute(query: query, completion: { result in
            switch result {
            case let .success(value):
                XCTAssertNotNil(value)
            case let .failure(apiError):
                print(apiError)
                XCTFail()
            }
            responseExpectation.fulfill()
        })
        
        wait(for: [responseExpectation], timeout: 10.0)
    }
    
}
