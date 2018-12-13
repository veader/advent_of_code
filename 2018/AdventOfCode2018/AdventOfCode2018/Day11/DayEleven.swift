//
//  DayEleven.swift
//  AdventOfCode2018
//
//  Created by Shawn Veader on 12/12/18.
//  Copyright © 2018 Shawn Veader. All rights reserved.
//

import Foundation

extension Coordinate {
    func power(serial: Int) -> Int {
        let rackID = x + 10

        var powerLevel = rackID * y
        powerLevel += serial
        powerLevel *= rackID

        let hundreds = (powerLevel - (powerLevel/1000) * 1000)/100

        return hundreds - 5
    }
}

struct DayEleven: AdventDay {
    var dayNumber: Int = 11

    struct PowerGrid {
        let fuelCells: [Coordinate: Int]
        let serial: Int
        let gridSize: Int // width & height -> square

        init(serial: Int, size: Int = 300) {
            self.serial = serial
            self.gridSize = size

            var cells = [Coordinate: Int]()

            // calculate fuelCell power levels
            for x in 0..<size {
                for y in 0..<size {
                    let cell = Coordinate(x: x, y: y)
                    cells[cell] = cell.power(serial: serial)
                }
            }

            self.fuelCells  = cells
        }

        func subGridTotal(size: Int, anchor: Coordinate) -> Int {
            let range = 0..<gridSize
            guard range.contains(anchor.x),
                  range.contains(anchor.x + size),
                  range.contains(anchor.y),
                  range.contains(anchor.y + size)
                else { return Int.min }

            var coordinates = [Coordinate]()
            for x in anchor.x..<(anchor.x + size) {
                for y in anchor.y..<(anchor.y + size) {
                    coordinates.append(Coordinate(x: x, y: y))
                }
            }
            assert(coordinates.count == size*size)

            return coordinates.reduce(0, { result, c in
                result + (fuelCells[c] ?? 0)
            })
        }

        typealias PowerGridResponse = (coordinate: Coordinate, max: Int)
        func calculateMax(size: Int = 3) -> PowerGridResponse? {
            var maxValue = Int.min
            var maxAnchor = Coordinate(x: -1, y: -1)

            for x in 0..<(gridSize - size) {
                for y in 0..<(gridSize - size) {
                    let anchor = Coordinate(x: x, y: y)
                    let max = subGridTotal(size: size, anchor: anchor)
                    if max > maxValue {
                        maxValue = max
                        maxAnchor = anchor
                    }
                    // TODO: stop when you start to decrease...
                }
            }

            return (coordinate: maxAnchor, max: maxValue)
        }
    }


    @discardableResult func run(_ input: String? = nil, _ part: Int? = 1) -> Any {
        if part == 1 {
            let answer = partOne()
            print("Day \(dayNumber) Part \(part!): Final Answer \(answer)")
            return answer
        } else {
            let answer = partTwo()
            print("Day \(dayNumber) Part \(part!): Final Answer \(answer)")
            return answer
        }
    }

    func partOne() -> Coordinate {
        let grid = PowerGrid(serial: 1309)
        guard let max = grid.calculateMax() else { return Coordinate(x: -1, y: -1) }
        print(max)
        return max.coordinate
    }

    func partTwo() -> Coordinate {
        let grid = PowerGrid(serial: 1309)

        var maxValue = Int.min
        var maxAnchor: Coordinate = Coordinate(x: -1, y: -1)

        for size in 3...300 {
            if let max = grid.calculateMax(size: size) {
                print("\(size): \(max)")
                if max.max > maxValue {
                    maxValue = max.max
                    maxAnchor = max.coordinate
                }
            }
        }

        print("\(maxAnchor) \(maxValue)")
        return maxAnchor
    }

    /*
     func partTwo(tree: LicenseTree) -> Int {
         guard let rootNode = tree.rootNode else { return Int.min }
         return sumNodeValue(for: rootNode)
     }
     */
}
