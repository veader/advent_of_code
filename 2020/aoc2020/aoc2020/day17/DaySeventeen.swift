//
//  DaySeventeen.swift
//  aoc2020
//
//  Created by Shawn Veader on 12/17/20.
//

import Foundation

struct DaySeventeen: AdventDay {
    var dayNumber: Int = 17

    func partOne(input: String?) -> Any {
        let source = PowerSource(input ?? "")
        source.run(cycles: 6, shouldPrint: true)
        return source.activeCubes
    }

    func partTwo(input: String?) -> Any {
        let scanner = TicketScanner(input ?? "")
        let departureValues = scanner.findDepartureFieldsInMyTicket()

        return departureValues.reduce(1, *)
    }
}
