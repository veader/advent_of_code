//
//  AdventDay.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/1/21.
//

import Foundation
import AppKit

protocol AdventDay {
    /// Year for this day, used for data paths, etc.
    var year: Int { get }

    /// Number of the day, used for data paths and other debugging info.
    var dayNumber: Int { get }

    /// Title of the day's problem, just used in UI
    var dayTitle: String { get }

    /// Number of stars earned for this day.
    var stars: Int { get }

    /// The default input for this Advent Day.
    /// - Note: Default implementation looks for `data/dayXinput.txt` file
    var defaultInput: String? { get }

    /// Run the necessary steps to calculate solution for this Advent Day.
    @discardableResult func run(part: Int?, _ input: String?) -> Any

    /// Run part one for this Advent Day.
    @discardableResult func partOne(input: String?) -> Any

    /// Run part two for this Advent Day.
    @discardableResult func partTwo(input: String?) -> Any
}

extension AdventDay {
    var id: String { "\(year):\(dayNumber)" }

    /// Returns the contents of the data file for this day.
    var defaultInput: String? {
        guard
            let asset = NSDataAsset(name: "\(year)_day\(String(format: "%02d", dayNumber))"),
            let output = String(data: asset.data, encoding: .utf8)
        else { return nil }
        return output
//        let path = "\(dataPath)/day\(dayNumber)input.txt"
//        return try? String(contentsOfFile: path, encoding: .utf8)
    }

    /// Return the data path.
    private var dataPath: String {
        guard let dir = ProcessInfo.processInfo.environment["PROJECT_DIR"] else {
            print("Day \(dayNumber): 💥 NO PROJECT DIR")
            exit(11)
        }

        return "\(dir)/AdventOfCode/\(year)/Data"
    }

    @discardableResult func run(part: Int? = 1, _ input: String? = nil) -> Any {
        guard let input = input ?? defaultInput else {
            print("Day \(dayNumber): NO INPUT")
            exit(10)
        }

        if part == 1 {
            let answer = partOne(input: input)
            print("Day \(dayNumber) Part \(part!): Final Answer \(answer)")
            return answer
        } else {
            let answer = partTwo(input: input)
            print("Day \(dayNumber) Part \(part!): Final Answer \(answer)")
            return answer
        }
    }
}
