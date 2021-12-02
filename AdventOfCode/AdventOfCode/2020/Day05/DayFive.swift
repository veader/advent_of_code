//
//  DayFive.swift
//  aoc2020
//
//  Created by Shawn Veader on 12/5/20.
//

import Foundation

struct DayFive2020: AdventDay {
    var year = 2020
    var dayNumber = 5
    var dayTitle = "Binary Boarding"
    var stars = 2

    func parse(_ input: String?) -> [BoardingPass] {
        (input ?? "").split(separator: "\n").map(String.init).compactMap { BoardingPass($0) }
    }

    func partOne(input: String?) -> Any {
        let passes = parse(input)
        let seatIDs = passes.map { $0.seatID }
        return seatIDs.max()!
    }

    func partTwo(input: String?) -> Any {
        let passes = parse(input)
        let seatIDs = passes.map({ $0.seatID }).sorted()

        let range = seatIDs.min()!...seatIDs.max()!
        let totalSet = Set(range)
        let missing = Set(seatIDs).symmetricDifference(totalSet)

        return missing.first!
    }
}
