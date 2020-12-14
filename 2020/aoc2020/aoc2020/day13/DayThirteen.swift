//
//  DayThirteen.swift
//  aoc2020
//
//  Created by Shawn Veader on 12/14/20.
//

import Foundation

struct DayThirteen: AdventDay {
    var dayNumber: Int = 13

    func parse(_ input: String?) -> BusSchedule? {
        BusSchedule.parse(input)
    }

    func partOne(input: String?) -> Any {
        guard let schedule = parse(input) else { return -1 }
        let answer = schedule.findEarliestBus(brute: true)
        let delta = answer.time - schedule.earliestDepartureTime
        return delta * answer.bus
    }

    func partTwo(input: String?) -> Any {
        return -1
    }
}
