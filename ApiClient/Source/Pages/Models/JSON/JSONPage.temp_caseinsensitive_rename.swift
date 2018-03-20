//
//  JsonPage.swift
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

//class JsonPage: Page {
//    private let data: JSON
//
//    // Properties
//    let pageSections = [JsonPageSection]()
//
//    // Computed properties
//    let itemId: Int {
//        return data["item_id"].intValue
//    }
//    let name: String {
//        return data["name"].stringValue
//    }
//    let country: String {
//        return data["country"].stringValue
//    }
//    let numberOfItems: Int{
//        let itemCount = 0
//        for section:JsonPageSection in pageSections{
//            itemCount += section.numberOfItems
//        }
//        return itemCount
//    }
//
//    // Initialize using Data object returned by the API (failable initializer)
//    required init?(jsonData: Data) {
//        do {
//            try data = JSON(data: jsonData)
//            parsePageSections()
//        } catch {
//            return nil
//        }
//    }
//
//    // Extract the page sections from the JSON
//    private func parsePageSections(){
//        for (_,subJson):(String, JSON) in data["page_sections"] {
//            let section = JsonPageSection(pageName: subJson["name"].stringValue, jsonData: subJson["items"])
//            pageSections.append(section)
//        }
//    }
//
//}

struct JSONPage: Page {
    let itemId: String
    let name: String
    let country: String
    let icon: URL?
    let name: String
    let sections: [PageSection]
}
