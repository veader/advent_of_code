//
//  DayThirteen.swift
//  aoc2020
//
//  Created by Shawn Veader on 12/14/20.
//

import Foundation

struct DayThirteen2020: AdventDay {
    var year = 2020
    var dayNumber = 13
    var dayTitle = "Shuttle Search"
    var stars = 1

    func parse(_ input: String?) -> BusSchedule? {
        BusSchedule.parse(input)
    }

    func partOne(input: String?) -> Any {
        guard let schedule = parse(input) else { return -1 }
        let answer = schedule.findEarliestBus()
        let delta = answer.time - schedule.earliestDepartureTime
        return delta * answer.bus
    }

    func partTwo(input: String?) -> Any {
        return -1
    }
}
