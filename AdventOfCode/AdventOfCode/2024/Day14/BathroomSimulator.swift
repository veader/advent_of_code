//
//  BathroomSimulator.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/15/24.
//

import Foundation

struct BathroomBot: Identifiable, Equatable, Hashable {
    let id: UUID = UUID()
    let position: Coordinate
    let velocity: Coordinate.GridDelta

    // matches p=90,62 v=-84,86
    static let botRegex = /p=(\d+),(\d+)\sv=(-?\d+),(-?\d+)/

    init?(input: String) {
        guard
            let match = input.firstMatch(of: BathroomBot.botRegex),
            let x = Int(match.1),
            let y = Int(match.2),
            let dx = Int(match.3),
            let dy = Int(match.4)
        else { return nil }

        position = Coordinate(x: x, y: y)
        velocity = Coordinate.GridDelta(x: dx, y: dy)
    }
}

class BathroomSimulator {
    var bots: [BathroomBot]
    var positions: [BathroomBot: Coordinate]
    let width: Int
    let height: Int

    var shouldPrint = false
    typealias BathroomQuadrant = (width: Range<Int>, height: Range<Int>)

    init(bots: [BathroomBot], width: Int, height: Int) {
        self.bots = bots
        self.width = width
        self.height = height

        // start bots at their initial positions
        positions = [:]
        for bot in bots {
            positions[bot] = bot.position
        }
    }

    func quadrants() -> [BathroomQuadrant] {
        [
            (0..<width/2,         0..<height/2), // top-left
            ((width/2)+1..<width, 0..<height/2), // top-right
            (0..<width/2,         (height/2)+1..<height), // bottom-left
            ((width/2)+1..<width, (height/2)+1..<height), // bottom-right
        ]
    }

    func bathroomMap() -> GridMap<Int> {
        GridMap(items: Array(repeating: Array(repeating:0, count: height), count: width))
    }

    func tick(seconds: Int = 1) async {
        var sec = 0

        while sec < seconds {
            var daMap: GridMap<Int> = GridMap(items: [])
            if shouldPrint {
                daMap = bathroomMap()
            }

            for bot in bots {
                if let position = await move(bot: bot) {
                    if shouldPrint {
                        daMap.update(at: position, by: { $0 + 1 })
                    }

                    positions[bot] = position
                }
            }

            if shouldPrint {
                print("----------------------------------------------------")
                print("SECONDS: \(sec)")
                printBathroom(map: daMap)
            }

            sec += 1
        }
    }

    func safetyFactor() -> Int {
        quadrants().reduce(1) { factor, quad in
            quad.width.reduce(0) { width, x in
                width + quad.height.reduce(0) { height, y in
                    height + bots(at: Coordinate(x: x, y: y))
                }
            } * factor
        }
    }

    @discardableResult
    func printBathroom(map bathroomMap: GridMap<Int>) -> String {
        let output = bathroomMap.gridAsString(transform: { item in
            guard let item, item > 0 else { return "." }
            return "\(item)"
        })

        print(output)
        return output
    }

    func bots(at location: Coordinate) -> Int {
        bots.reduce(0) { count, bot in
            positions[bot] == location ? count + 1 : count
        }
    }

    private func move(bot: BathroomBot) async -> Coordinate? {
        guard let currentPosition = positions[bot] else { return nil }

        // calculate the new position based on velocity changes
        let newPosition = currentPosition.moving(xOffset: bot.velocity.x, yOffset: bot.velocity.y)

        // determine if any "transporting" is done across the space of the bathroom
        var finalX = newPosition.x
        if newPosition.x < 0 {
            finalX = width + newPosition.x
        } else if newPosition.x >= width {
            finalX = newPosition.x - width
        }

        var finalY = newPosition.y
        if newPosition.y < 0 {
            finalY = height + newPosition.y
        } else if newPosition.y >= height {
            finalY = newPosition.y - height
        }

        // update position
        return Coordinate(x: finalX, y: finalY)
    }
}
