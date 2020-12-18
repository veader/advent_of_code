//
//  AdventDay.swift
//  aoc2020
//
//  Created by Shawn Veader on 12/1/20.
//

import Foundation

protocol AdventDay {
    /// Number of the day, used for data paths and other debugging info.
    var dayNumber: Int { get }

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

        return "\(dir)/aoc2020/data"
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

class Advent {
    static func day(_ day: Int) -> AdventDay? {
        switch day {
        case 1:
            return DayOne()
        case 2:
            return DayTwo()
        case 3:
            return DayThree()
        case 4:
            return DayFour()
        case 5:
            return DayFive()
        case 6:
            return DaySix()
        case 7:
            return DaySeven()
        case 8:
            return DayEight()
        case 9:
            return DayNine()
        case 10:
            return DayTen()
        case 11:
            return DayEleven()
        case 12:
            return DayTwelve()
        case 13:
            return DayThirteen()
        case 14:
            return DayFourteen()
        case 15:
            return DayFifteen()
        case 16:
            return DaySixteen()
        case 17:
            return DaySeventeen()
        default:
            return nil
        }
    }
}
