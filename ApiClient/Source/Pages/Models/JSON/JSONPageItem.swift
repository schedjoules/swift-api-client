//
//  JSONPageItem.swift
//  ApiClient
//
//  Created by Balazs Vincze on 2018. 01. 09..
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

import Foundation

struct JSONPageItem: PageItem {
    // Required properties
    let name: String
    let itemID: Int?
    let url: String
    let itemClass: ItemClass
    
    // Optional properties
    let icon: URL?
    let categoryID: Int?
    let category: String?
    let country: String?
    let sport: String?
    let season: String?
    let gender: String?
}

// MARK: - Decodable protocol
extension JSONPageItem: Decodable {
    // JSON keys
    enum PageItemKeys: String, CodingKey {
        // Top-level keys
        case item
        case itemClass = "item_class"
        
        // Nested keys
        case name
        case country
        case category
        case url
        case icon
        case sport
        case gender
        case season
        case itemID     = "item_id"
        case categoryID = "category_id"
    }
    
    init(from decoder: Decoder) throws {
        // Get data containers
        let container = try decoder.container(keyedBy: PageItemKeys.self)
        let itemContainer = try container.nestedContainer(keyedBy: PageItemKeys.self, forKey: .item)
        
        // Decode required values
        let name = try itemContainer.decode(String.self, forKey: .name)
        let itemID = try itemContainer.decode(Int?.self, forKey: .itemID)
        let url = try itemContainer.decode(String.self, forKey: .url)
        let itemClass = try container.decode(ItemClass.self, forKey: .itemClass)
        
        // Decode optional values
        let icon = try itemContainer.decodeIfPresent(URL.self, forKey: .icon)
        let categoryID = try itemContainer.decodeIfPresent(Int.self, forKey: .categoryID)
        let category = try itemContainer.decodeIfPresent(String.self, forKey: .category)
        let country = try itemContainer.decodeIfPresent(String.self, forKey: .country)
        let sport = try itemContainer.decodeIfPresent(String.self, forKey: .sport)
        let season = try itemContainer.decodeIfPresent(String.self, forKey: .season)
        let gender = try itemContainer.decodeIfPresent(String.self, forKey: .gender)
        
        // Initialize with the decoded values
        self.init(name: name, itemID: itemID, url: url, itemClass: itemClass, icon: icon, categoryID: categoryID, category: category, country: country, sport: sport, season: season, gender: gender)
    }
}
