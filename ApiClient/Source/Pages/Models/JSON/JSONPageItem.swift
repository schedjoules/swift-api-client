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
    let itemID: Int
    let name: String
    let categoryID: Int
    let url: String
    let icon: URL?
    let category: String
    let itemClass: ItemClass
    
    // Optional properties
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
        
        // Get values
        let itemClass = try container.decode(ItemClass.self, forKey: .itemClass)
        let itemID = try itemContainer.decode(Int.self, forKey: .itemID)
        let name = try itemContainer.decode(String.self, forKey: .name)
        let category = try itemContainer.decode(String.self, forKey: .category)
        let categoryID = try itemContainer.decode(Int.self, forKey: .categoryID)
        let url = try itemContainer.decode(String.self, forKey: .url)
        let icon = try itemContainer.decode(URL.self, forKey: .icon)
        
        // Optional properties
        let country = try itemContainer.decodeIfPresent(String.self, forKey: .country)
        let sport: String? = try itemContainer.decodeIfPresent(String.self, forKey: .sport)
        let season: String? = try itemContainer.decodeIfPresent(String.self, forKey: .season)
        let gender: String? = try itemContainer.decodeIfPresent(String.self, forKey: .gender)
        
        self.init(itemID: itemID, name: name, categoryID: categoryID, url: url, icon: icon, category: category, itemClass: itemClass, country: country, sport: sport, season: season, gender: gender)
    }
}
