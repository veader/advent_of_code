//
//  DayEleven.swift
//  aoc2020
//
//  Created by Shawn Veader on 12/11/20.
//

import Foundation

struct DayEleven2020: AdventDay {
    var year = 2020
    var dayNumber = 11
    var dayTitle = "Seating System"
    var stars = 2

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
        let finalGen = modeler.findFinalGeneration(visible: true)
        return finalGen.occupiedSeats
    }
}
