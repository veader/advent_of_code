//
//  DaySixteen.swift
//  aoc2020
//
//  Created by Shawn Veader on 12/16/20.
//

import Foundation

struct DaySixteen2020: AdventDay {
    var year = 2020
    var dayNumber = 16
    var dayTitle = "Ticket Translation"
    var stars = 2

    func partOne(input: String?) -> Any {
        let scanner = TicketScanner(input ?? "")
        let errors = scanner.findNearbyTicketErrors()

        return errors.reduce(0, +)
    }

    func partTwo(input: String?) -> Any {
        let scanner = TicketScanner(input ?? "")
        let departureValues = scanner.findDepartureFieldsInMyTicket()

        return departureValues.reduce(1, *)
    }
}
