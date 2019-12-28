//
//  TractorBeam.swift
//  aoc2019
//
//  Created by Shawn Veader on 12/28/19.
//  Copyright © 2019 Shawn Veader. All rights reserved.
//

import Foundation

struct TractorBeam {
    let instructions: String
    var map: [Coordinate: Int]

    var visited: [Coordinate]

    init(input: String) {
        instructions = input
        map = [Coordinate: Int]()
        visited = [Coordinate]()
    }

    var affectedSquares: Int {
        map.filter({ $0.value == 1}).count
    }

    /// Monitor a square grid of a given size for the beam's location
    mutating func monitor(gridSize: Int = 10) {
        for y in (0..<gridSize) {
            for x in (0..<gridSize) {
                flyDrone(to: Coordinate(x: x, y: y))
            }
        }
    }

    /// Perform a slightly smarter search. Instead of going from 0 to grid size,
    /// locate a portion of the beam and search around it till hitting an non-beam
    /// location.
    mutating func searchSmarter(starting: Coordinate = Coordinate.origin, maxGridSize: Int = 100) {
        var visitQueue = [Coordinate]()

        // start at the origin
        visitQueue.append(starting)

        while !visitQueue.isEmpty {
            let location = visitQueue.removeFirst()
            guard !visited.contains(location) else { continue }

            if location.x > (starting.x + maxGridSize) || location.y > (starting.y + maxGridSize) {
                // print("We are outside the max grid size")
                continue
                // break
            }

            visited.append(location)
            if flyDrone(to: location) == 1 {
                // if the tractor beam is here, look to neighboring locations
                visitQueue.append(contentsOf: relaventLocations(for: location))

                // is this row the right size wide?
                let rowBeam = map.filter({ $0.key.y == location.y && $0.value == 1 }).sorted(by: { $0.key.x < $1.key.x })
                let rowSize = rowBeam.count
                if rowSize >= 100 { // looking for 100 wide row
                    print("Row \(location.y) is \(rowSize) starting at \(rowBeam.first?.key ?? Coordinate.origin)")
                }
            }
        }
    }

    /// Search for the first location that will contain a box of the given size within the beam.
    mutating func searchForBox(size: Int = 100, hint: Coordinate = Coordinate.origin) -> Coordinate? {
        var topLocation = hint
        var bottomLocation = topLocation
        let rightSize = size - 1
        var travelingBackUp = false
        var previousSuccess: Coordinate?

        while true {
            // print("")
            // make sure the top location is the start of the beam on this row..
            if flyDrone(to: topLocation.location(for: .west)) == 1 {
                topLocation = Coordinate(x: topLocation.x - 200, y: topLocation.y)
            }
            if flyDrone(to: topLocation) == 0 {
                guard let start = search(row: topLocation.y, hint: topLocation.x) else {
                    print("Unable to find the start of the row from \(topLocation)")
                    return nil
                }

                // print("Adjusting top location from \(topLocation) to \(start)")
                topLocation = start
            }

            // print("Loop: starting @ \(topLocation) - Beam width: \(beamWidth(at: topLocation))")

            // jump down by the step size and find the start of the beam
            bottomLocation = Coordinate(x: topLocation.x, y: topLocation.y + rightSize)
            if flyDrone(to: bottomLocation) == 0 {
                guard let start = search(row: bottomLocation.y, hint: bottomLocation.x) else {
                    print("Unable to find start of bottom row from \(bottomLocation)")
                    return nil
                }
                // print("Adjusting bottom location from \(bottomLocation) to \(start)")
                bottomLocation = start
            }
            // print("Bottom: \(bottomLocation)")

            let topLeft = Coordinate(x: bottomLocation.x, y: topLocation.y)
            if testBoxCorners(origin: topLeft, size: size) {
                print("Box fits @ \(topLeft)")
                previousSuccess = topLeft

                // try moving back up one to see if it still fits
                travelingBackUp = true
                topLocation = Coordinate(x: topLeft.x - 200, y: topLeft.y - 1)
                continue // skip bottom of loop
            } else {
                print("Box doesn't fit with top left @ \(topLeft)")

                if travelingBackUp {
                    // since we are stepping back up by one the previous success is the answer
                    return previousSuccess
                }
            }

            // move the whole search down and continue
            topLocation = Coordinate(x: topLocation.x, y: topLocation.y + 30)
        }
    }

    mutating func testBoxCorners(origin: Coordinate, size: Int) -> Bool {
        let rightSize = size - 1
        let topRight = Coordinate(x: origin.x + rightSize, y: origin.y)
        let bottomLeft = Coordinate(x: origin.x, y: origin.y + rightSize)
        let bottomRight = Coordinate(x: origin.x + rightSize, y: origin.y + rightSize)

        return flyDrone(to: origin) == 1 &&
            flyDrone(to: topRight) == 1 &&
            flyDrone(to: bottomLeft) == 1 &&
            flyDrone(to: bottomRight) == 1
    }

    /// Search for the first row that matches the given width. Hint can be used to speed it up...
    mutating func searchForRow(width: Int, hint: Int = 100) -> Int {
        var row = hint
        var startHint = 0

        while true {
            print("Searching row \(row)")
            if let start = search(row: row, hint: startHint) {
                print("\tStart at: \(start)")
                startHint = start.x // update start hint to save time

                if testBeam(at: start, width: width) {
                    print("\tWide enough!")
                    break
                }
            }

            row += 1 // move down to the next row
        }

        return row
    }

    /// Search a row (y) to find where the beam starts.
    /// - parameters:
    ///     - row: Y coordinate to search
    ///     - hint: X offset. Defaults to 0
    /// - returns: Coordinate where the beam if first found
    mutating func search(row: Int, hint: Int = 0) -> Coordinate? {
        var startLocation: Coordinate? = nil
        var currentLocation = Coordinate(x: hint, y: row)

        while true {
            if flyDrone(to: currentLocation) == 1 {
                startLocation = currentLocation
                break
            }

            // move to the next one
            currentLocation = currentLocation.location(for: .east)
        }

        return startLocation
    }

    /// Determine if the beam is a certain width starting at the given location.
    /// - parameters:
    ///     - location: Starting location for the test. Assumed to be the "left" side of the beam.
    ///     - width: Test width used in calculation. (Starting location.y + width)
    /// - returns: Bool indicating if width matches.
    mutating func testBeam(at location: Coordinate, width: Int) -> Bool {
        let endLocation = Coordinate(x: location.x + width, y: location.y)
        return flyDrone(to: endLocation) == 1
    }

    /// Determine the width of the beam at the given location.
    /// - parameters:
    ///     - location: Starting location of the beam. Assumed to be the "left" side of the beam.
    /// - returns: Width of the beam for the row.
    mutating func beamWidth(at location: Coordinate) -> Int {
        var searchLocation = location
        while true {
            if flyDrone(to: searchLocation) == 0 {
                // we've hit the end
                return searchLocation.x - location.x
            } else {
                searchLocation = searchLocation.location(for: .east)
            }
        }
    }

    /// Determine all "nearby" locations to look for the beam.
    ///
    /// Currently defined as the box of coordinates in +5  x & y
    private func relaventLocations(for coordinate: Coordinate) -> [Coordinate] {
        (coordinate.y..<coordinate.y+5).flatMap { y -> [Coordinate] in
            (coordinate.x..<coordinate.x+5).map { Coordinate(x: $0, y: y) }
        }
    }

    /// Fly a drone to the given location and use an IntCodeMachine to see what's up
    @discardableResult
    private mutating func flyDrone(to location: Coordinate) -> Int {
        // save some time if we've been here before
        if let value = map[location] {
            return value
        }

        // machine only runs once for a given coordinate
        let machine = IntCodeMachine(instructions: instructions)
        machine.silent = true
        machine.inputs = [location.x, location.y]

        // start the machine running
        machine.run()

        var finished = false
        while !finished {
            if case .finished(output: _) = machine.state {
                finished = true
            } else if case .awaitingInput = machine.state {
                finished = true
            } else {
                print("What is \(machine.state)")
            }
        }

        let output = machine.outputs.last ?? -1
        self.map[location] = output
        return output
    }

    @discardableResult
    func printMap(starting: Coordinate = Coordinate.origin, gridSize: Int = 10) -> String {
        var output = ""

        for y in (starting.y..<(starting.y + gridSize)) {
            for x in (starting.x..<(starting.x + gridSize)) {
                let location = Coordinate(x: x, y: y)
                if let response = map[location] {
                    if response == 1 {
                        output += "#"
                    } else {
                        output += "."
                    }
                } else {
                    output += " "
                }
            }
            output += "\n"
        }

        print(output)
        return output
    }
}
