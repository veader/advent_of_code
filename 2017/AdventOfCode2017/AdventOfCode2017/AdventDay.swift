//
//  AdventDay.swift
//  AdventOfCode2017
//
//  Created by Shawn Veader on 12/1/17.
//  Copyright © 2017 v8logic. All rights reserved.
//

protocol AdventDay {
    /// Run the necessary steps to calculate solution for this Advent Day
    func run(_ input: String?)

    /// The default input for this Advent Day
    func defaultInput() -> String?
}

protocol Testable: AdventDay {
    /// Run tests by exercising run() method with different inputs
    func runTests()
}

extension AdventDay {
    @discardableResult
    func testValue(_ value1: Any?, equals value2: Any?) -> Bool {
        var matches = false

        if (value1 == nil && value2 == nil) {
            // both values are nil, that's equal
            matches = true
        } else if let v1 = value1, let v2 = value2 {
            // if both are ints, test them for equality
            if v1 is Int && v2 is Int {
                matches = (v1 as! Int) == (v2 as! Int)
            } else if v1 is String && v2 is String {
                // if both are strings, test them for equality
                matches = (v1 as! String) == (v2 as! String)
            }
        } else {
            // one of the values is nil, that's not
            matches = false
        }

        if (!matches) {
            print("💥 \(String(describing: value1)) does not equal \(String(describing: value2))")
        }

        return matches
    }
}

