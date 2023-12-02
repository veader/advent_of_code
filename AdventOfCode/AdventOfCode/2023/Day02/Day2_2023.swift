//
//  Day2_2023.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/2/23.
//

import Foundation

struct Day2_2023: AdventDay {
    var year = 2023
    var dayNumber = 2
    var dayTitle = "Cube Conundrum"
    var stars = 1

    enum Day1Error: Error {
        case invalidInput
    }

    func parse(_ input: String?, translate: Bool = false) -> [CubeGame] {
        (input ?? "").split(separator: "\n").map(String.init).compactMap { CubeGame.parse($0) }
    }

    func partOne(input: String?) -> Any {
        let maxes: CubeGame.Turn = [
            .red: 12,
            .green: 13,
            .blue: 14,
        ]

        let validGames = parse(input).filter { $0.valid(maxes: maxes) }
        return validGames.reduce(0) { $0 + $1.id }
    }

    func partTwo(input: String?) -> Any {
        0
    }
}
