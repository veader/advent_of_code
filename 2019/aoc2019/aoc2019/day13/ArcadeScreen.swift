//
//  ArcadeScreen.swift
//  aoc2019
//
//  Created by Shawn Veader on 12/13/19.
//  Copyright © 2019 Shawn Veader. All rights reserved.
//

import Foundation

class ArcadeScreen {
    enum Tile: Int {
        case empty = 0
        case wall = 1
        case block = 2
        case paddle = 3
        case ball = 4

        var draw: String {
            switch self {
            case .empty:
                return " "
            case .wall:
                return "▓"
            case .block:
                return "░"
            case .paddle:
                return "═"
            case .ball:
                return "◍"
            }
        }
    }

    var grid: [Coordinate: Tile] = [Coordinate: Tile]()

    var ballLocation: Coordinate? {
        grid.filter({ $0.value == .ball }).first?.key
    }

    var paddleLocation: Coordinate? {
        grid.filter({ $0.value == .paddle }).first?.key
    }

    var centerX: Int {
        let maxX = grid.keys.max(by: { $0.x < $1.x })?.x ?? 1
        return maxX / 2
    }

    func draw(input: [Int]) {
        let screenInput = input.chunks(size: 3)

        for tileInput in screenInput {
            guard tileInput.count == 3 else {
                print("Chunk has \(tileInput.count), which isn't right.")
                continue
            }

            if let tile = ArcadeScreen.Tile(rawValue: tileInput[2]) {
                let location = Coordinate(x: tileInput[0], y: tileInput[1])
                draw(tile: tile, at: location)
            } else {
                print("Could not draw output: \(tileInput)")
            }
        }
    }

    /// Draw the a tile at a location
    func draw(tile: Tile, at location: Coordinate) {
        grid[location] = tile
    }

    /// Is there a "solid" object at the point (ie: block or wall)
    func solid(at location: Coordinate) -> Bool {
        guard let tile = grid[location] else { return false }

        switch tile {
        case .block, .wall:
            return true
        default:
            return false
        }
    }

    @discardableResult
    func printScreen() -> String {
        let ranges = printRanges()
        let xRange = ranges.0
        let yRange = ranges.1

        var output = " "
        xRange.forEach { output += "\($0 % 10)" }
        output += "\n"
        for y in yRange {
            output += "\(y % 10)"
            for x in xRange {
                let location = Coordinate(x: x, y: y)
                if let tile = grid[location] {
                    output += tile.draw
                } else {
                    output += Tile.empty.draw
                }
            }
            output += "\n"
        }

        print(output)
        return output
    }

    func printPath(of ball: PongBall) {
        let ranges = printRanges()
        let xRange = ranges.0
        let yRange = ranges.1

        var output = " "
        xRange.forEach { output += "\($0 % 10)" }
        output += "\n"
        for y in yRange {
            output += "\(y % 10)"
            for x in xRange {
                let location = Coordinate(x: x, y: y)
                if ball.bounces.contains(location) {
                    output += "*"
                } else if ball.pathSteps.contains(location) {
                    output += "¤"
                } else if let tile = grid[location] {
                    output += tile.draw
                } else {
                    output += Tile.empty.draw
                }
            }
            output += "\n"
        }

        print(output)
    }

    func printRanges() -> (Range<Int>, Range<Int>) {
        let usedCoordinates = grid.keys
        let minX = usedCoordinates.min(by: { $0.x < $1.x })?.x ?? 0
        let maxX = usedCoordinates.max(by: { $0.x < $1.x })?.x ?? 0
        let minY = usedCoordinates.min(by: { $0.y < $1.y })?.y ?? 0
        let maxY = usedCoordinates.max(by: { $0.y < $1.y })?.y ?? 0

        let xRange = min(0, minX)..<(maxX + 1)
        let yRange = min(0, minY)..<(maxY + 1)

        return (xRange, yRange)
    }
}
