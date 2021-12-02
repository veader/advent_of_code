//
//  DayTwo2021.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/1/21.
//

import Foundation

struct DayTwo2021: AdventDay {
    var year = 2021
    var dayNumber = 2
    var dayTitle = "Dive!"
    var stars = 1

    func parse(_ input: String?) -> [Submarine.Command] {
        (input ?? "")
            .split(separator: "\n")
            .map(String.init)
            .compactMap { Submarine.Command.parse($0) }
    }

    func partOne(input: String?) -> Any {
        let commands = parse(input)
        let sub = Submarine(commands: commands)
        sub.dive()
        return sub.output
    }

    func partTwo(input: String?) -> Any {
        return 0
    }

    class Submarine {
        enum Command{
            /// Move sub forward X units
            case forward(distance: Int)
            /// Move sub down X units in depth
            case down(depth: Int)
            /// Move sub up X units in depth
            case up(depth: Int)

            /// Parse the given input string into a Command
            static func parse(_ input: String) -> Command? {
                // https://rubular.com/r/w78gSaYgWS3JsP
                let commandRegEx = "(\\w+)\\s(\\d+)"

                guard
                    let match = input.matching(regex: commandRegEx),
                    let cmd = match.captures.first,
                    let int = Int(match.captures.last ?? "")
                else { return nil }

                switch cmd {
                case "forward":
                    return .forward(distance: int)
                case "down":
                    return .down(depth: int)
                case "up":
                    return .up(depth: int)
                default:
                    print("Unknown command: \(input)")
                    return nil
                }
            }
        }

        var commands: [Command]
        var depth: Int = 0
        var distance: Int = 0

        var output: Int { depth * distance }

        init(commands: [Command]) {
            self.commands = commands
        }

        /// Run the current set of commands
        func dive() {
            commands.forEach { cmd in
                switch cmd {
                case .forward(distance: let d):
                    distance += d
                case .down(depth: let d):
                    depth += d
                case .up(depth: let d):
                    depth -= d
                }
            }
        }
    }
}
