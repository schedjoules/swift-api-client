//
//  JSONPage.swift
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

struct JSONPage: Page {
    // Required properties
    let name: String
    let itemID: Int?
    let sections: [PageSection]
    
    // Optional properties
    let country: String?
    let icon: URL?
}

// MARK: - Decodable protocol
extension JSONPage: Decodable {
    // JSON keys
    enum PageKeys: String, CodingKey {
        case name
        case country
        case icon
        case itemID = "item_id"
        case sections = "page_sections"
    }
    
    init(from decoder: Decoder) throws {
        // Get data container
        let container = try decoder.container(keyedBy: PageKeys.self)
        
        // Decode required values
        let name = try container.decode(String.self, forKey: .name)
        let itemID = try container.decode(Int?.self, forKey: .itemID)
        let sections = try container.decode([JSONPageSection].self, forKey: .sections)
        
        // Decode optional values
        let country = try container.decodeIfPresent(String.self, forKey: .country)
        let icon = try container.decodeIfPresent(URL.self, forKey: .icon)
        
        // Initialize with the decoded values
        self.init(name: name, itemID: itemID, sections: sections, country: country, icon: icon)
    }
}
