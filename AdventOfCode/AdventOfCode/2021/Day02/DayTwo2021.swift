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
    var stars = 2

    func parse(_ input: String?) -> [Submarine.Command] {
        (input ?? "")
            .split(separator: "\n")
            .map(String.init)
            .compactMap { Submarine.Command.parse($0) }
    }

    func partOne(input: String?) -> Any {
        let commands = parse(input)
        let sub = Submarine(commands: commands, mode: .simple)
        sub.dive()
        return sub.output
    }

    func partTwo(input: String?) -> Any {
        let commands = parse(input)
        let sub = Submarine(commands: commands, mode: .useAim)
        sub.dive()
        return sub.output
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

        enum Mode {
            case simple
            case useAim
        }

        var commands: [Command]
        var mode: Mode
        var depth: Int = 0
        var distance: Int = 0
        var aim: Int = 0

        var output: Int { depth * distance }

        init(commands: [Command], mode: Mode = .useAim) {
            self.commands = commands
            self.mode = mode
        }

        /// Run the current set of commands
        func dive() {
            commands.forEach { cmd in
                switch cmd {
                case .forward(distance: let d):
                    distance += d
                    if case .useAim = mode {
                        depth += (aim * d)
                    }
                case .down(depth: let d):
                    if case .simple = mode {
                        depth += d
                    } else {
                        aim += d
                    }
                case .up(depth: let d):
                    if case .simple = mode {
                        depth -= d
                    } else {
                        aim -= d
                    }
                }
            }
        }
    }
}
