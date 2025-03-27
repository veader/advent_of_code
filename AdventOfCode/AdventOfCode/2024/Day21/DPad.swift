//
//  DPad.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 1/3/25.
//

import Foundation

class DPad {
    protocol Padable {
        static var startingPoint: Coordinate { get }
        static var voidPoint: Coordinate { get }
    }

    enum NumPadButton: String, Padable {
        case activate = "A"
        case void = ""
        case zero = "0"
        case one = "1"
        case two = "2"
        case three = "3"
        case four = "4"
        case five = "5"
        case six = "6"
        case seven = "7"
        case eight = "8"
        case nine = "9"

        /// Start over the A in the bottom-right corner (origin at 0x0)
        static var startingPoint: Coordinate { Coordinate(x: 2, y: 3) }
        /// Void is in bottom-left corner (origin at 0x0)
        static var voidPoint: Coordinate { Coordinate(x: 0, y: 3) }
    }

    /// +---+---+---+
    /// | 7 | 8 | 9 |
    /// +---+---+---+
    /// | 4 | 5 | 6 |
    /// +---+---+---+
    /// | 1 | 2 | 3 |
    /// +---+---+---+
    ///     | 0 | A |
    ///     +---+---+
    let numPad = GridMap<NumPadButton>(items: [
        [.seven, .eight, .nine],
        [.four,  .five,  .six],
        [.one,   .two,   .three],
        [.void,  .zero,  .activate],
    ])

    enum DPadButton: String, Padable {
        case activate = "A"
        case void = ""
        case up = "^"
        case left = "<"
        case down = "v"
        case right = ">"

        /// Start over the A in the top-right corner (origin at 0x0)
        static var startingPoint: Coordinate { Coordinate(x: 2, y: 0) }
        /// Void is in top-left corner (origin at 0x0)
        static var voidPoint: Coordinate { Coordinate.origin }
    }

    ///     +---+---+
    ///     | ^ | A |
    /// +---+---+---+
    /// | < | v | > |
    /// +---+---+---+
    let deePad = GridMap<DPadButton>(items: [
        [.void, .up, .activate],
        [.left, .down, .right],
    ])

    /// Translate the given input into directional inputs given the number of intermediate robots.
    func translate(_ input: String, robotCount: Int = 3) -> [DPadButton] {
        var moves = translateNumToDPad(input)

        var robot = 1 // count the first robot...?
        while robot < robotCount {
            moves = translateDPadToDPad(moves)
            robot += 1
        }

        return moves
    }

    /// Takes an input value (ie: "206A") and converts it into moves on a directional pad
    /// which will make the robots press the buttons in order.
    func translateNumToDPad(_ input: String) -> [DPadButton] {
        let moves: [NumPadButton] = input.charSplit().compactMap { NumPadButton(rawValue: $0) }
        return translateToDPad(moves, pad: numPad)
    }

    /// Given a set of directional pad button presses, create the appropriate steps
    /// to input these on a directional pad. (Turtles all the way down)
    func translateDPadToDPad(_ input: [DPadButton]) -> [DPadButton] {
        translateToDPad(input, pad: deePad)
    }

    /// Translate the generic input button presses into directional pad button presses
    /// based on the supplied input pad. (Could be num pad or directional pad).
    private func translateToDPad<T:Padable&Equatable>(_ input: [T], pad: GridMap<T>) -> [DPadButton] {
        // using protocol information, infer the location of the void point and where we start
        guard let sampleButton = pad.item(at: .origin) else {
            print("Unable to find first button to get static data...")
            return []
        }

        let voidLocation = type(of: sampleButton).voidPoint
        var fingerLocation = type(of: sampleButton).startingPoint
        var moves = [DPadButton]()

        for button in input {
            guard let buttonLocation = pad.first(where: { $0 == button }) else {
                print("Unable to find button \(button)")
                return []
            }

            if fingerLocation != buttonLocation { // avoid work if finger is already over the button...
                // determine steps to move from current location to button location
                let delta = fingerLocation.delta(to: buttonLocation, originTopLeft: true)

                // tactics to avoid crossing over the "void"
                if fingerLocation.y == voidLocation.y {
                    // current position is on our row, prioritize moving up/down first

                    var direction: DPadButton = .up

                    if delta.y > 0 {
                        direction = .down
                    } else {
                        direction = .up
                    }
                    for _ in 0..<abs(delta.y) {
                        moves.append(direction)
                    }

                    if delta.x > 0 {
                        direction = .right
                    } else {
                        direction = .left
                    }
                    for _ in 0..<abs(delta.x) {
                        moves.append(direction)
                    }
                } else {
                    // destination (button) position is on row with void, prioritize moving left/right first
                    // or... void on neither but still just move left/right first
                    var direction: DPadButton = .up

                    if delta.x > 0 {
                        direction = .right
                    } else {
                        direction = .left
                    }
                    for _ in 0..<abs(delta.x) {
                        moves.append(direction)
                    }

                    if delta.y > 0 {
                        direction = .down
                    } else {
                        direction = .up
                    }
                    for _ in 0..<abs(delta.y) {
                        moves.append(direction)
                    }
                }
            }

            // now that we are over the button, press it
            moves.append(.activate)

            fingerLocation = buttonLocation // update finger location
        }

        return moves
    }
}
