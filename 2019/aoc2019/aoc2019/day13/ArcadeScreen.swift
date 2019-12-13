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
        case horizontalPaddle = 3
        case ball = 4

        var draw: String {
            switch self {
            case .empty:
                return " "
            case .wall:
                return "▓"
            case .block:
                return "░"
            case .horizontalPaddle:
                return "═"
            case .ball:
                return "◍"
            }
        }
    }

    var grid: [Coordinate: Tile] = [Coordinate: Tile]()

    func draw(input: [Int]) {
//        print(input)
//        print("")
        let screenInput = input.chunks(size: 3)
//        screenInput.forEach { print($0) }

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

    func draw(tile: Tile, at location: Coordinate) {
        grid[location] = tile
    }

    @discardableResult
    func printScreen() -> String {
        let usedCoordinates = grid.keys
        let minX = usedCoordinates.min(by: { $0.x < $1.x })?.x ?? 0
        let maxX = usedCoordinates.max(by: { $0.x < $1.x })?.x ?? 0
        let minY = usedCoordinates.min(by: { $0.y < $1.y })?.y ?? 0
        let maxY = usedCoordinates.max(by: { $0.y < $1.y })?.y ?? 0

        let xRange = minX..<maxX
        let yRange = minY..<maxY

        var output = ""
        for y in yRange {
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
}
