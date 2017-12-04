//
//  AdventDay.swift
//  AdventOfCode2017
//
//  Created by Shawn Veader on 12/1/17.
//  Copyright © 2017 v8logic. All rights reserved.
//

import Foundation

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
    /// Read the contents of the file at the given path
//    func readData(from path: String) -> String? {
//        guard let file = FileHandle(forReadingAtPath: path) else { return nil }
//        defer { file.closeFile() }
//
//        if let contents = file.readDataToEndOfFile(),
//            let dataAsString =
//    }

    func dataPath() -> String {
        guard let dir = ProcessInfo.processInfo.environment["PROJECT_DIR"] else {
            print("Day 4: 💥 NO PROJECT DIR")
            exit(11)
        }

        return "\(dir)/AdventOfCode2017/data"
    }

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

/*
struct DayX: AdventDay {

  // MARK: -

  func defaultInput() -> String? {
    return ""
  }

  func run(_ input: String? = nil) {
    guard let runInput = input ?? defaultInput() else {
      print("Day X: 💥 NO INPUT")
      exit(10)
     }

     let thing = partOne(input: runInput)
     guard let answer = thing else {
       print("Day X: (Part 1) 💥 Unable to calculate answer.")
       exit(1)
     }
     print("Day X: (Part 1) Answer ", answer)

     // ...
   }

   // MARK: -

   func partOne(input: String) -> Int? {
     return nil
   }

   func partTwo(input: String) -> Int? {
     return nil
   }
}

extension DayX: Testable {
  func runTests() {
  }
}

 */

