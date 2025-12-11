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
    @discardableResult func run(part: Int?, _ input: String?) async -> Any

    /// Run part one for this Advent Day.
    @discardableResult func partOne(input: String?) async -> Any

    /// Run part two for this Advent Day.
    @discardableResult func partTwo(input: String?) async -> Any
}

extension AdventDay {
    var id: String { "\(year):\(dayNumber)" }

    /// Returns the contents of the data file for this day from the asset catalog
    var defaultInput: String? {
        guard
            let asset = NSDataAsset(name: "\(year)_day\(String(format: "%02d", dayNumber))"),
            let output = String(data: asset.data, encoding: .utf8)
        else { return nil }
        return output
    }

    @discardableResult func run(part: Int? = 1, _ input: String? = nil) async -> Any {
        guard let input = input ?? defaultInput else {
            print("Day \(dayNumber): NO INPUT ")
            exit(10)
        }

        if part == 1 {
            let answer = await partOne(input: input)
            print("Day \(dayNumber) Part \(part!): Final Answer \(answer)")
            return answer
        } else {
            let answer = await partTwo(input: input)
            print("Day \(dayNumber) Part \(part!): Final Answer \(answer)")
            return answer
        }
    }
}
