//
//  Day8_2025.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/8/25.
//

import Foundation

struct Day8_2025: AdventDay {
    var year = 2025
    var dayNumber = 8
    var dayTitle = ""
    var stars = 2

    func parse(_ input: String?) -> [ThreeDCoordinate] {
        (input ?? "").lines().compactMap { ThreeDCoordinate($0) }
    }

    func partOne(input: String?) -> Any {
        let count = 1000

        let coordinates = parse(input)
        let space = ThreeDSpace(coordinates: coordinates)
        let (circuits, _) = space.buildConnections(count)

        let score = space.topThreeScore(circuits: circuits)
        return score ?? 0
    }

    func partTwo(input: String?) -> Any {
        let coordinates = parse(input)
        let space = ThreeDSpace(coordinates: coordinates)
        let (_, lastVector) = space.buildConnections()
        guard let lastVector else { return -1 }
        print(lastVector)
        return lastVector.start.x * lastVector.end.x
    }
}
