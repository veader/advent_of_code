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
    var stars = 0

    func parse(_ input: String?) -> [ThreeDCoordinate] {
        (input ?? "").lines().compactMap { ThreeDCoordinate($0) }
    }

    func partOne(input: String?) -> Any {
        let count = 1000
        let coordinates = parse(input)
        print("Coordinates: \(coordinates.count)")
        let space = ThreeDSpace(coordinates: coordinates)
        print("Found \(space.distanceMap.count) vectors.")

        let circuits = space.buildConnections(count)
        print("Found \(circuits.count) circuits after \(count) connections.")

        let score = space.topThreeScore(circuits: circuits)
        return score ?? 0
    }

    func partTwo(input: String?) async -> Any {
        guard let map = TeleportMap.parse(input: input) else { return 0 }
        return await map.findPathCount()
    }
}
