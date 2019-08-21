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
    var fo: Int
    var la: Double
    var lo: Double
    var to: String    
    var ty: String
    
}

// MARK: - Decodable protocol
extension JSONWeatherAnnotation: Decodable {
    // JSON keys
    enum PageKeys: String, CodingKey {
        case fo
        case la
        case lo
        case to
        case ty
    }
    
    init(from decoder: Decoder) throws {
        // Get data container
        let container = try decoder.container(keyedBy: PageKeys.self)
        
        // Decode required values
        let fo = try container.decode(Int.self, forKey: .fo)
        let la = try container.decode(Double.self, forKey: .la)
        let lo = try container.decode(Double.self, forKey: .lo)
        let to = try container.decode(String.self, forKey: .to)
        let ty = try container.decode(String.self, forKey: .ty)
        
        // Initialize with the decoded values
        self.init(fo: fo, la: la, lo: lo, to: to, ty: ty)
    }
}
