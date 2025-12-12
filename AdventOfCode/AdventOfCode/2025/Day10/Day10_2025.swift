//
//  Day10_2025.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/10/25.
//

import Foundation

struct Day10_2025: AdventDay {
    var year = 2025
    var dayNumber = 10
    var dayTitle = "Factory"
    var stars = 1

    func parse(_ input: String?) -> [JoltageMachine] {
        (input ?? "").lines().compactMap { JoltageMachine($0) }
    }

    func partOne(input: String?) -> Any {
        let machines = parse(input)

        // TODO: parallelize this?
        return machines.reduce(0) { result, machine in
            let (count, _) = machine.findShortestPath()
            return result + count
        }
    }

    func partTwo(input: String?) -> Any {
        let machines = parse(input)

        return machines.reduce(0) { result, machine in
            let (count, _) = machine.findJoltageShortestPath()
            return result + count
        }
    }
}
