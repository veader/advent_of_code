//
//  DayEleven.swift
//  aoc2020
//
//  Created by Shawn Veader on 12/11/20.
//

import Foundation

struct DayEleven: AdventDay {
    var dayNumber: Int = 11

    func parse(_ input: String?) -> SeatMap? {
        SeatMap(input)
    }

    func partOne(input: String?) -> Any {
        guard let map = parse(input) else { return -1 }
        let modeler = SeatMapModeler(map: map)
        let finalGen = modeler.findFinalGeneration()
        return finalGen.occupiedSeats
    }

    func partTwo(input: String?) -> Any {
        guard let map = parse(input) else { return -1 }
        let modeler = SeatMapModeler(map: map)
        return 0
    }
}
