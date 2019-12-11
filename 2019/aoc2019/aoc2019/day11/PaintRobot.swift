//
//  PaintRobot.swift
//  aoc2019
//
//  Created by Shawn Veader on 12/11/19.
//  Copyright © 2019 Shawn Veader. All rights reserved.
//

import Foundation

class PaintingRobot {
    enum PanelColor: Int {
        case black = 0
        case white = 1

        var printed: String {
            switch self {
            case .black:
                return "."
            case .white:
                return "#"
            }
        }
    }

    /// Internal IntCodeMachine used to navigate/operate the paint robot
    private let machine: IntCodeMachine

    /// Number of times the robot
    var paintedPanels: [Coordinate: PanelColor]

    /// Current orientation the robot is facing (starts facing north)
    var orientation: Orientation

    /// Current location of the robot (starts at 0,0)
    var location: Coordinate

    init(input: String) {
        machine = IntCodeMachine(instructions: input)
        machine.silent = true

        paintedPanels = [Coordinate: PanelColor]()
        orientation = .north
        location = Coordinate.origin
    }

    /// Execute instructions and paint until finished
    func run() {
        var finished = false

        // to start the machine off, we will prime the input with black
        machine.set(input: PanelColor.black.rawValue)

        // start the machine running
        machine.run()

        while !finished {
            if case .finished(output: _) = machine.state {
                processInstructions()
                printArea()
                finished = true
            } else if case .awaitingInput = machine.state {
                // first look at the last instructions
                guard processInstructions() else {
                    finished = true
                    return
                }
                // printArea()

                // now give the color of the current panel as input
                let panelColor: PanelColor = paintedPanels[location] ?? .black
                machine.set(input: panelColor.rawValue)
            } else {
                print(".")
            }
        }
    }

    /// Process the last two outputs as instructions.
    /// - returns Boolean indicating success (ie: instructions found and executed properly)
    @discardableResult
    private func processInstructions() -> Bool {
        guard let instructions = machine.outputs.last(count: 2) else {
            print("Machine awaiting input but doesn't have enought output to give...")
            return false
        }

        // the first of the outputs should be color to paint current location
        let color = PanelColor(rawValue: instructions[0])
        paintedPanels[location] = color

        // the next instruction should the direction to turn
        let direction = instructions[1]
        guard [0,1].contains(direction) else {
            print("Direction instructions not correct... \(direction)")
            return false
        }

        if direction == 0 {
            orientation = orientation.turnLeft()
        } else {
            orientation = orientation.turnRight()
        }

        moveForward()

        return true
    }

    /// Given our current orientation, take one step forward
    private func moveForward() {
        switch orientation {
        case .north:
            location = Coordinate(x: location.x, y: location.y + 1)
        case .south:
            location = Coordinate(x: location.x, y: location.y - 1)
        case .east:
            location = Coordinate(x: location.x + 1, y: location.y)
        case .west:
            location = Coordinate(x: location.x - 1, y: location.y)
        }
    }

    @discardableResult
    func printArea(showRobot: Bool = true) -> String {
        // determine bounds of painted region
        let sortedX = paintedPanels.keys.map { $0.x }.sorted().unique()
        let minX = sortedX.min() ?? 0
        let maxX = sortedX.max() ?? 0

        let sortedY = paintedPanels.keys.map { $0.y }.sorted().unique()
        let minY = sortedY.min() ?? 0
        let maxY = sortedY.max() ?? 0

        let spacer = 2 // extra padding around painted regions

        var output = ""
        for y in ((minY - spacer)..<(maxY + spacer)) {
            for x in ((minX - spacer)..<(maxX + spacer)) {
                let coord = Coordinate(x: x, y: y)
                if location == coord && showRobot {
                    // draw robot (even if current panel is painted)
                    output += orientation.printed
                } else if let color = paintedPanels[coord] {
                    output += color.printed
                } else {
                    output += PanelColor.black.printed
                }
            }
            output += "\n"
        }

        print(output)
        return output
    }
}
