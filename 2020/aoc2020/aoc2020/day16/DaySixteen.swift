//
//  DaySixteen.swift
//  aoc2020
//
//  Created by Shawn Veader on 12/16/20.
//

import Foundation

struct DaySixteen: AdventDay {
    var dayNumber: Int = 16

    func partOne(input: String?) -> Any {
        let scanner = TicketScanner(input ?? "")
        let errors = scanner.findNearbyTicketErrors()

        return errors.reduce(0, +)
    }

    func partTwo(input: String?) -> Any {
        return -1
    }
}
