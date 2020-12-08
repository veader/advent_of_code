//
//  DayFive.swift
//  aoc2020
//
//  Created by Shawn Veader on 12/5/20.
//

import Foundation

struct DayFive: AdventDay {
    var dayNumber: Int = 5

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
