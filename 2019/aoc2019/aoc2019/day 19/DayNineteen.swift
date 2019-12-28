//
//  DayNineteen.swift
//  aoc2019
//
//  Created by Shawn Veader on 12/19/19.
//  Copyright © 2019 Shawn Veader. All rights reserved.
//

import Foundation

struct DayNineteen: AdventDay {
    var dayNumber: Int = 19

    func partOne(input: String?) -> Any {
        let size = 50
        print("Start: \(Date())")
        var beam = TractorBeam(input: input ?? "")
        beam.monitor(gridSize: size)
        print("End: \(Date())")
        beam.printMap(gridSize: size)

        return beam.affectedSquares
    }

    func partTwo(input: String?) -> Any {

        // IDEA: pick a row... (maybe offer hint to not start from x=0)?
        //  - find where it "starts" and determine how wide it is.
        //  - if it's < 100, skip up 100 - width? (maybe offer hint to not start from x=0)?
        //  - the "start" is the bottom left of box. determine if top left & top right are `#`
        //      - if so; is top right.x + 1 `.` (otherwise need to move "up")
        //      - if not; jump down another 10 rows?

        // let size = 100
        var beam = TractorBeam(input: input ?? "")

        //        print("Start: \(Date())")
        //        let startLocation = Coordinate.origin // Coordinate(x: 90, y: 50)
        //        beam.searchSmarter(starting: startLocation, maxGridSize: 1000)
        //        print("End: \(Date())")

        // let row = beam.searchForRow(width: 100, hint: 100)
        // let first100Row = 258 // just a "wild" guess LOL

        // let startLocation = Coordinate(x: 450, y: 258)
        let startLocation = Coordinate(x: 1246, y: 708)
        if let topLeft = beam.searchForBox(size: 100, hint: startLocation) {
            print(topLeft)
            // 14930741 is too high
            // 14220708 is too high
            return (topLeft.x * 10_000) + topLeft.y
        }

        // beam.printMap(starting: startLocation, gridSize: size)

        return 0
    }
}
