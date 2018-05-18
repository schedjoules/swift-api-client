//
//  Parser.swift
//  iCalendarParser
//
//  Created by Balazs Vincze on 2018. 02. 16..
//  Copyright © 2018. SchedJoules. All rights reserved.
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
import Result

struct EventKeys {
    static let eventBegin = "BEGIN:VEVENT"
    static let eventEnd = "END:VEVENT"
}

public enum ParseError: Error{
    case networkError(String)
}

/**
 This class is used to parse `iCalendar` files.
 
 - Warning:
 The parser has only been tested with SchedJoules generated `iCalendar` files. It is not guranteed to work on files with even slightly different formatting.
 */
public final class Parser {
    /// Parse the parameters into a dictionary
    private static func parse(params: [String]) -> [String:String] {
        var paramsDict = [String:String]()
        for param in params{
            let paramExploded = param.components(separatedBy: "=")
            paramsDict[paramExploded[0]] = paramExploded[1]
        }
        return paramsDict
    }
    
    /// Parse a single line of the ICS file
    private static func parse(line: String) -> ParsedLine {
        let firstPart = line.components(separatedBy: ":")[0]
        let value = String(line.dropFirst(firstPart.count+1))
        
        if firstPart.contains(";"){
            let key = firstPart.components(separatedBy: ";")[0]
            let paramsStripped = firstPart.dropFirst(key.count+1).components(separatedBy: ";")
            let params = parse(params: paramsStripped)
            let parsedLine = ParsedLine(key: key, value: value, params: params)
            return parsedLine
        } else {
            let key = firstPart
            let parsedLine = ParsedLine(key: key, value: value, params: nil)
            return parsedLine
        }
    }
    
    /// Parse the lines of the ICS file
    private static func parse(lines: [String]) -> [ParsedLine] {
        var parsedLines = [ParsedLine]()
        for line in lines{
            let parsedLine = parse(line: line)
            parsedLines.append(parsedLine)
        }
        return parsedLines
    }
    
    /// Parse ICS file
    public static func parse(ics: String) -> ICalendar {
        // Events to return
        var events = [Event]()
        
        // Keep track of parsing
        var inEvent = false
        
        // Break up the ics into seperate lines
        let lines = ics.components(separatedBy: CharacterSet.newlines)
        
        // Iterate over the lines
        var eventLines = [String]()
        for line in lines {
            if line == EventKeys.eventBegin {
                inEvent = true
            } else if line == EventKeys.eventEnd {
                inEvent = false
                let parsedLine = parse(lines: eventLines)
                let event = Event(with: parsedLine)
                events.append(event)
                eventLines.removeAll()
            } else if inEvent {
                eventLines.append(line)
            }
        }
        return ICalendar(events: events)
    }
}

