//
//  CubeGame.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/2/23.
//

import Foundation
import RegexBuilder

struct CubeGame {

    enum CubeColor: String, Identifiable, CaseIterable {
        case red
        case green
        case blue

        var id: String { rawValue }
    }

    typealias Turn = [CubeColor: Int]

    let id: Int
    let turns: [Turn]


    /// Is this game valid given the maxes?
    func valid(maxes: Turn) -> Bool {
        let invalid = turns.compactMap { turn -> Turn? in
            guard
                (turn[.red] ?? 0)   <= (maxes[.red] ?? 0),
                (turn[.green] ?? 0) <= (maxes[.green] ?? 0),
                (turn[.blue] ?? 0)  <= (maxes[.blue] ?? 0)
            else { return turn }
            return nil
        }

        // game is only valid if all turns are valid
        return invalid.isEmpty
    }

    func minimumCubes() -> Turn {
        var mins = Turn()

        for turn in turns {
            for color in CubeColor.allCases {
                if (turn[color] ?? 0) > (mins[color] ?? 0) {
                    mins[color] = turn[color]
                }
            }
        }

        return mins
    }

    var power: Int {
        minimumCubes().reduce(1) { result, foo in
            result * foo.value
        }
    }


    // MARK: - Static

    private static let gameIDRegex = /^Game (\d+):/
    private static let cubeRegex = /(\d+) (red|green|blue)/

    static func parse(_ input: String) -> CubeGame? {
        // sample: Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue

        var tmpInput = input

        // find our game ID
        guard let gameMatch = tmpInput.firstMatch(of: gameIDRegex), let gameID = Int(gameMatch.output.1) else { return nil }

        // move input past game ID info
        tmpInput = String(tmpInput.suffix(from: gameMatch.range.upperBound))

        // create each turn
        let turnStrings = tmpInput.split(separator: ";").map(String.init)
        let turns = turnStrings.compactMap { str -> Turn? in
            var turn = Turn()
            let cubes = str.split(separator: ",").map(String.init)

            for cube in cubes {
                guard
                    let match = cube.firstMatch(of: cubeRegex),
                    let count = Int(match.output.1),
                    let color = CubeColor(rawValue: String(match.output.2))
                else { continue }

                turn[color] = count
            }

            return turn
        }

        return CubeGame(id: gameID, turns: turns)
    }
}
