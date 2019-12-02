//
//  AdventDay.swift
//  aoc2019
//
//  Created by Shawn Veader on 12/1/19.
//  Copyright © 2019 Shawn Veader. All rights reserved.
//

import Foundation

protocol AdventDay {
    /// Number of the day, used for data paths and other debugging info.
    var dayNumber: Int { get }

    /// The default input for this Advent Day.
    /// - Note: Default implementation looks for `data/dayXinput.txt` file
    var defaultInput: String? { get }

    /// Run the necessary steps to calculate solution for this Advent Day.
    @discardableResult func run(_ input: String?, _ part: Int?) -> Any
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

        return "\(dir)/aoc2019/data"
    }
}
