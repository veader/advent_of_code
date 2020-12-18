//
//  ExperimentalPowerSource.swift
//  aoc2020
//
//  Created by Shawn Veader on 12/17/20.
//

import Foundation

class ExperimentalPowerSource {
    /// Map of the pocket dimension where the 3D coordinate locates the ConwayCube
    var pocketDimension: [FourDCoordinate: ConwayCube<FourDCoordinate>]

    var xRange: ClosedRange<Int> {
        range { $0.x }
    }

    var yRange: ClosedRange<Int> {
        range { $0.y }
    }

    var zRange: ClosedRange<Int> {
        range { $0.z }
    }

    var wRange: ClosedRange<Int> {
        range { $0.w }
    }

    var activeCubes: Int {
        pocketDimension.values.filter({ $0.isActive }).count
    }

    init(_ input: String) {
        var pocketMap = [FourDCoordinate: ConwayCube<FourDCoordinate>]()

        let lines = input.split(separator: "\n").map(String.init)
        for (y, line) in lines.enumerated() {
            for (x, space) in line.map(String.init).enumerated() {
                let coord = FourDCoordinate(x: x, y: y, z: 0, w: 0)
                var isActive = false

                if space == "#" {
                    isActive = true
                }

                let cube = ConwayCube(coordinate: coord, isActive: isActive)
                pocketMap[coord] = cube
            }
        }

        pocketDimension = pocketMap
    }

    func run(cycles: Int, shouldPrint: Bool = false) {
        if shouldPrint {
            print(self)
        }

        (1...cycles).forEach { cycleCount in
            cycle()
            if shouldPrint {
                print("After \(cycleCount) cycles")
                print(self)
            }
        }
    }

    func cycle() {
        let theXRange = xRange
        let theYRange = yRange
        let theZRange = zRange
        let theWRange = wRange

        let expandedXRange = (theXRange.lowerBound - 1)...(theXRange.upperBound + 1)
        let expandedYRange = (theYRange.lowerBound - 1)...(theYRange.upperBound + 1)
        let expandedZRange = (theZRange.lowerBound - 1)...(theZRange.upperBound + 1)
        let expandedWRange = (theWRange.lowerBound - 1)...(theWRange.upperBound + 1)

        var pocketMap = [FourDCoordinate: ConwayCube<FourDCoordinate>]()

        for w in expandedWRange {
            for z in expandedZRange {
                for y in expandedYRange {
                    for x in expandedXRange {
                        let coord = FourDCoordinate(x: x, y: y, z: z, w: w)
                        var cube = pocketDimension[coord] ?? ConwayCube(coordinate: coord, isActive: false)

                        let neighbors = coord.neighboringCoordinates
                        // determine how many active neighbors this coordinate has
                        let activeNeighborCount = neighbors.filter({
                            guard let cube = pocketDimension[$0] else { return false }
                            return cube.isActive
                        }).count

                        if cube.isActive {
                            if !(2...3).contains(activeNeighborCount) {
                                cube = cube.flipped // switch from active to inactive
                            }
                        } else { // inactive
                            if activeNeighborCount == 3 {
                                cube = cube.flipped // switch from inactive to active
                            }
                        }

                        pocketMap[coord] = cube
                    }
                }
            }
        }

        pocketDimension = pocketMap
    }

    private func range(dimension: (FourDCoordinate) -> Int) -> ClosedRange<Int> {
        let dimensions = pocketDimension.filter({ $0.value.isActive }).keys.map({ dimension($0) })
        let min = dimensions.min() ?? 0
        let max = dimensions.max() ?? 0
        return min...max
    }
}

extension ExperimentalPowerSource: CustomDebugStringConvertible {
    var debugDescription: String {
        var outputLines = [String]()
        var line = ""

        for w in wRange {
            for z in zRange {
                outputLines.append("\nz=\(z), w=\(w)")
                for y in yRange {
                    line = "" // clear the line
                    for x in xRange {
                        let coord = FourDCoordinate(x: x, y: y, z: z, w: w)
                        if let cube = pocketDimension[coord] {
                            line += "\(cube)"
                        } else {
                            line += "." // default to inactive
                        }
                    }
                    outputLines.append(line)
                }
            }
        }

        return outputLines.joined(separator: "\n") + "\n"
    }
}
