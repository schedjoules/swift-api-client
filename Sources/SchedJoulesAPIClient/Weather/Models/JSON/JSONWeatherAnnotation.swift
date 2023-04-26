//
//  JSONWeatherAnnotation.swift
//  ApiClient
//
//  Created by Alberto Huerdo on 2019. 08. 21..
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
//

import Foundation


struct JSONWeatherAnnotation: WeatherAnnotation {
    //The identifier of the anotation
    var id: Int
    //The latitude where to place the annotation
    var latitude: Double
    //The longitude where to place the annotation
    var longitude: Double
    //The name of the POI used for display
    var name: String
    //The group tells you if the returned marker is (c)lustered or (i)ndividual.
    //Clustered markers can be zoomed into and will show more markers.
    var group: WeatherAnnotationGroup
}

// MARK: - Decodable protocol
extension JSONWeatherAnnotation: Decodable {
    // JSON keys
    enum CodingKeys: String, CodingKey {
        case id = "fo"
        case latitude = "la"
        case longitude = "lo"
        case name = "to"
        case group = "ty"
    }
    
    init(from decoder: Decoder) throws {
        // Get data container
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Decode required values
        let id = try container.decode(Int.self, forKey: .id)
        let latitude = try container.decode(Double.self, forKey: .latitude)
        let longitude = try container.decode(Double.self, forKey: .longitude)
        let name = try container.decode(String.self, forKey: .name)
        let group = try container.decode(WeatherAnnotationGroup.self, forKey: .group)
        
        // Initialize with the decoded values
        self.init(id: id, latitude: latitude, longitude: longitude, name: name, group: group)
    }
}
