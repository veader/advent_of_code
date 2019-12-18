//
//  DaySeventeen.swift
//  aoc2019
//
//  Created by Shawn Veader on 12/17/19.
//  Copyright © 2019 Shawn Veader. All rights reserved.
//

import Foundation

struct Camera {
    let pixels: [Coordinate: String]

    init(input: [Int]) {
        var tmpPixels = [Coordinate: String]()
        var y = 0

        // print out comes in top first, reorient to be "corret"
        let lines = input.split(separator: 10).map(Array.init) //.reversed()
        for line in lines {
            for (x, ascii) in line.enumerated() {
                if let scalar = UnicodeScalar(ascii) {
                    tmpPixels[Coordinate(x: x, y: y)] = String(Character(scalar))
                }
            }
            y += 1
        }

        pixels = tmpPixels
    }

    func intersections() -> [Coordinate] {
        let directions: [MoveDirection] = [.north, .east, .south, .west]

        // coordinates for all scaffold pieces
        let scaffold = pixels.filter { $0.value == "#" }.keys

        return scaffold.compactMap { coordinate -> Coordinate? in
            let neighbors = directions.compactMap { direction -> Coordinate? in
                let location = coordinate.location(for: direction)
                guard scaffold.contains(location) else { return nil }

                return location
            }

            // intersections have 4 neighbors
            guard neighbors.count == 4 else { return nil }
            return coordinate
        }
    }

    func printScreen() {
        let usedCoordinates = pixels.keys
        let minX = usedCoordinates.min(by: { $0.x < $1.x })?.x ?? 0
        let maxX = usedCoordinates.max(by: { $0.x < $1.x })?.x ?? 0
        let minY = usedCoordinates.min(by: { $0.y < $1.y })?.y ?? 0
        let maxY = usedCoordinates.max(by: { $0.y < $1.y })?.y ?? 0

        let xRange = min(0, minX - 2)..<(maxX + 2)
        let yRange = min(0, minY - 2)..<(maxY + 2)

        let ints = intersections()

        var output = ""
        for y in yRange { //.reversed() {
            for x in xRange {
                let location = Coordinate(x: x, y: y)
                if ints.contains(location) {
                    output += "O"
                } else {
                    output += pixels[location] ?? " "
                }
            }
            output += "\n"
        }
        print(output)
    }
}

struct VacuumRobot {
    let machine: IntCodeMachine
    lazy var camera: Camera = {
        Camera(input: machine.outputs)
    }()

    init(input: String) {
        machine = IntCodeMachine(instructions: input)
        machine.silent = true
    }

    func wakeUp() {
        machine.store(value: 2, at: 0)
    }

    func run() {
        var finished = false

        // start the machine running
        machine.run()

        while !finished {
            if case .finished(output: _) = machine.state {
                finished = true
            } else if case .awaitingInput = machine.state {
                print("Awaiting input")
                finished = true
            }
        }
    }
}

struct DaySeventeen: AdventDay {
    var dayNumber: Int = 17

    func partOne(input: String?) -> Any {
        var robot = VacuumRobot(input: input ?? "")
        robot.run()
        robot.camera.printScreen()

        let intersections = robot.camera.intersections()
        let answer = intersections.reduce(0) {  $0 + ($1.x * $1.y) }
        return answer
    }

    func partTwo(input: String?) -> Any {
        let robot = VacuumRobot(input: input ?? "")
        robot.wakeUp()

        let commands = "A,B,B,A,C,A,C,A,C,B\n" +    // main command
                       "L,6,R,12,R,8\n" +           // A function
                       "R,8,R,12,L,12\n" +          // B function
                       "R,12,L,12,L,4,L,4\n" +      // C function
                       "n\n"                        // print mode (off)
        let ascii = commands.compactMap { $0.asciiValue }.map(Int.init)
        // print(ascii)
        robot.machine.inputs = ascii

        robot.run()

        return robot.machine.outputs.last ?? -1
    }
}
