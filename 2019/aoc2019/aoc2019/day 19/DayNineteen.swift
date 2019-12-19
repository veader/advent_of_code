//
//  DayNineteen.swift
//  aoc2019
//
//  Created by Shawn Veader on 12/19/19.
//  Copyright © 2019 Shawn Veader. All rights reserved.
//

import Foundation

struct TractorBeam {
    let instructions: String
    var map: [Coordinate: Int]

    init(input: String) {
        instructions = input
        map = [Coordinate: Int]()
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

    /// Fly a drone to the given location and use an IntCodeMachine to see what's up
    private mutating func flyDrone(to location: Coordinate) {
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
                self.map[location] = machine.outputs.last ?? -1
            } else if case .awaitingInput = machine.state {
                finished = true
                self.map[location] = machine.outputs.last ?? -1
            } else {
                print("What is \(machine.state)")
            }
        }
    }

    @discardableResult
    func printMap(gridSize: Int = 10) -> String {
        var output = ""

        for y in (0..<gridSize) {
            for x in (0..<gridSize) {
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
        return 0
    }
}
