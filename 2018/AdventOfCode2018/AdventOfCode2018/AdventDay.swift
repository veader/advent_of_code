//
//  AdventDay.swift
//  AdventOfCode2018
//
//  Created by Shawn Veader on 12/2/18.
//  Copyright © 2018 Shawn Veader. All rights reserved.
//

import Foundation

protocol AdventDay {
    /// Number of the day, used for data paths and other debugging info.
    var dayNumber: Int { get }

    /// The default input for this Advent Day.
    /// - Note: Default implementation looks for `data/dayXinput.txt` file
    var defaultInput: String? { get }

    /// Run the necessary steps to calculate solution for this Advent Day.
    func run(_ input: String?)
}

extension AdventDay {
}

protocol Testable: AdventDay {
    /// Run tests by exercising run() method with different inputs
    func runTests()
}

extension AdventDay {
    /// Returns the contents of the data file for this day.
    var defaultInput: String? {
        let path = "\(dataPath)/day\(dayNumber)input.txt"
        return try? String(contentsOfFile: path, encoding: .utf8)
    }

    /// Return the data path.
    private var dataPath: String {
        guard let dir = ProcessInfo.processInfo.environment["PROJECT_DIR"] else {
            print("Day \(dayNumber): 💥 NO PROJECT DIR")
            exit(11)
        }

        return "\(dir)/AdventOfCode2018/data"
    }

//    @discardableResult
//    func testValue(_ value1: Any?, equals value2: Any?) -> Bool {
//        var matches = false
//
//        if (value1 == nil && value2 == nil) {
//            // both values are nil, that's equal
//            matches = true
//        } else if let v1 = value1, let v2 = value2 {
//            // if both are ints, test them for equality
//            if v1 is Int && v2 is Int {
//                matches = (v1 as! Int) == (v2 as! Int)
//            } else if v1 is String && v2 is String {
//                // if both are strings, test them for equality
//                matches = (v1 as! String) == (v2 as! String)
//            }
//        } else {
//            // one of the values is nil, that's not
//            matches = false
//        }
//
//        if (!matches) {
//            print("💥 \(String(describing: value1)) does not equal \(String(describing: value2))")
//        }
//
//        return matches
//    }
}
