//
//  JSONWeatherSettings.swift
//  ApiClient
//
//  Created by Alberto Huerdo on 2019. 06. 8..
//  Copyright © 2019 SchedJoules. All rights reserved.
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

struct JSONWeatherSettings: WeatherSettings {
    var rain: WeatherSettingsItem
    var wind: WeatherSettingsItem
    var temp: WeatherSettingsItem
    var time: WeatherSettingsItem
}

// MARK: - Decodable protocol
extension JSONWeatherSettings: Decodable {
    // JSON keys
    enum PageKeys: String, CodingKey {
        case rain
        case wind
        case temp
        case time
    }
    
    init(from decoder: Decoder) throws {
        // Get data container
        let container = try decoder.container(keyedBy: PageKeys.self)
        
        // Decode required values
        let rain = try container.decode(WeatherSettingsItem.self, forKey: .rain)
        let wind = try container.decode(WeatherSettingsItem.self, forKey: .wind)
        let temp = try container.decode(WeatherSettingsItem.self, forKey: .temp)
        let time = try container.decode(WeatherSettingsItem.self, forKey: .time)
        
        // Initialize with the decoded values
        self.init(rain: rain, wind: wind, temp: temp, time: time)
    }
}
