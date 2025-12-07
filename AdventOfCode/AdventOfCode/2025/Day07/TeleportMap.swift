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

    @discardableResult
    func traceTachyons() -> Int {
        var beams: [Coordinate] = [startLocation]
        var splits: Set<Coordinate> = []
        var newBeams: Set<Coordinate> = []
//        var iteration = 0

        while !beams.isEmpty {
            let y = beams.map { $0.y }.unique().map(String.init)
//            print("----------\nIteration: \(iteration)")
//            print("Row: \(y.joined())")
//            print("Beams: \(beams.count)")
//            print("New beams: \(newBeams.count)")

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
//            iteration += 1
//            map.printGrid()
        }

        return splits.count
    }
}
