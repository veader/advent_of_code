//
//  TeleportMap.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/7/25.
//

import Foundation

class TeleportMap {
    enum TeleportItems: String, CustomStringConvertible {
        case start = "S"
        case empty = "."
        case splitter = "^"
        case beam = "|"

        var description: String { rawValue }
    }

    let map: GridMap<TeleportItems>

    let startLocation: Coordinate

    init(map: GridMap<TeleportItems>, start: Coordinate) {
        self.map = map
        self.startLocation = start
    }

    static func parse(input: String?) -> TeleportMap? {
        guard let input, !input.isEmpty else { return nil }

        let items: [[TeleportItems]] = input.lines().map { line in
            line.charSplit().map { TeleportItems(rawValue: $0)! }
        }

        let map = GridMap(items: items)
        guard let start = map.first(where: { $0 == .start }) else { return nil }

        return TeleportMap(map: map, start: start)
    }

    /// Trace the tachyon particles through the space, splitting when a splitter is encountered, etc.
    /// - Returns: Total number of splits done during the tracing.
    @discardableResult
    func traceTachyons() -> Int {
        var beams: [Coordinate] = [startLocation]
        var splits: Set<Coordinate> = []
        var newBeams: Set<Coordinate> = []

        while !beams.isEmpty {
            for beam in beams {
                // check what is under the current beam
                let down = beam.moving(direction: .south, originTopLeft: true)
                guard map.valid(coordinate: down) else { continue } // stay on the map

                switch map.item(at: down) {
                case .empty, .beam:
                    // "copy" beam down
                    map.update(at: down, with: .beam)
                    newBeams.insert(down)
                case .splitter:
                    splits.insert(down)

                    // split the beam to each side of the splitter
                    let left = down.moving(direction: .west)
                    if map.valid(coordinate: left) {
                        map.update(at: left, with: .beam)
                        newBeams.insert(left)
                    }

                    let right = down.moving(direction: .east)
                    if map.valid(coordinate: right) {
                        map.update(at: right, with: .beam)
                        newBeams.insert(right)
                    }
                default:
                    // do nothing
                    print("Why are we here? \(map.item(at: down)?.rawValue ?? "X")")
                }
            }

            beams = Array(newBeams)
            newBeams = [] // clear it out
        }

        return splits.count
    }

    // IDEA: trace routes, then count beams from leaf to start (which rows to look at?)

    /// Search for the total number of paths possible from the starting location to the edge of the map.
    func findPathCount() async -> Int {
        await countPaths(from: startLocation)
    }

    /// Check "down" from the given coordinate and count the number of paths exposed.
    /// - Returns: Number of paths found "down" from this coordinate.
    private func countPaths(from coordinate: Coordinate) async -> Int {
        // check what is under the current beam
        let down = coordinate.moving(direction: .south, originTopLeft: true)

        // have we reached the end? if so, count this "route"
        guard map.valid(coordinate: down) else { return 1 }

        switch map.item(at: down) {
        case .empty:
            // going down straight
            return await countPaths(from: down)
        case .splitter:
            // split the beam to each side of the splitter
            let left = down.moving(direction: .west)
            let right = down.moving(direction: .east)

            if map.valid(coordinate: left) && map.valid(coordinate: right) {
                let answers = await withTaskGroup(of: Int.self, returning: [Int].self) { group in
                    group.addTask {
                        await self.countPaths(from: left)
                    }
                    group.addTask {
                        await self.countPaths(from: right)
                    }

                    var counts = [Int]()
                    for await result in group {
                        counts.append(result)
                    }
                    return counts
                }
                return answers.reduce(0, +)
//                let leftCount = await countPaths(from: left)
//                let rightCount = await countPaths(from: right)
//                return leftCount + rightCount
            } else {
                print("Error: Unable to split at \(down)")
                return 0
            }
        default:
            print("Why are we here? \(map.item(at: down)?.rawValue ?? "X")")
            return 0
        }
    }
}
