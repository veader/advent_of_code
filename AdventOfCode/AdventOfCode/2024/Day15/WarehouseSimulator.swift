//
//  WarehouseSimulator.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/15/24.
//

import Foundation
import RegexBuilder

class WarehouseSimulator {
    enum WarehouseItem: String {
        case wall = "#"
        case space = "."
        case box = "O"
        case robot = "@"
    }

    enum WarehouseMove: String {
        case up = "^"
        case down = "v"
        case left = "<"
        case right = ">"

        var direction: RelativeDirection {
            switch self {
                case .up: return .north
                case .down: return .south
                case .left: return .west
                case .right: return .east
            }
        }
    }

    let map: GridMap<WarehouseItem>
    let moves: [WarehouseMove]
    var botPosition: Coordinate = .origin
    var shouldPrint: Bool = false

    init (input: String) {
        let moveRegex = /^(\^|v|<|>)/
        let lines = input.lines()
        var mapLines: [String] = []
        var moveLines: [String] = []

        for line in lines {
            if let _ = line.firstMatch(of: moveRegex) {
                moveLines.append(line)
            } else {
                mapLines.append(line)
            }
        }

        let items: [[WarehouseItem]] = mapLines.map { line in
            line.charSplit().compactMap { c in
                WarehouseItem(rawValue: c)
            }
        }
        self.map = GridMap(items: items)

        let botMoves: [WarehouseMove] = moveLines.flatMap { line in
            line.charSplit().compactMap { c in
                WarehouseMove(rawValue: c)
            }
        }
        moves = botMoves

        findBot()
    }

    private func findBot() {
        guard let position = map.first(where: { $0 == .robot }) else { return }
        botPosition = position
    }

    func printMap() {
        print(map.gridAsString(transform: { $0?.rawValue ?? " " }))
    }

    func boxCoordinates() -> [Coordinate] {
        map.filter(by: { $1 == .box })
    }

    func boxScore() -> Int {
        boxCoordinates().reduce(0) { score, coordinate in
            score + (coordinate.y * 100) + coordinate.x
        }
    }

    func followMoves() {
        if shouldPrint {
            print("Initial State")
            printMap()
            print("\n")
        }

        // while something...
        for (idx, move) in moves.enumerated() {
            if shouldPrint {
                print("Move \(move.rawValue) [\(idx)]")
            }

            instructBot(move: move)

            if shouldPrint {
                printMap()
                print("\n")
            }
        }
    }

    func instructBot(move: WarehouseMove) {
        let position = botPosition.moving(direction: move.direction, originTopLeft: true)
        guard let itemAtPointer = map.item(at: position) else { return }

        if itemAtPointer == .space {
            // move
            map.update(at: botPosition, with: .space)
            botPosition = position // update position
            map.update(at: botPosition, with: .robot)
        } else if itemAtPointer == .wall {
            // don't move
            return
        } else if itemAtPointer == .box {
            // find if we have space to move this/these box(es)
            var boxes: [Coordinate] = [position]
            var spaceCoordinate: Coordinate?

            var boxPointer = position.moving(direction: move.direction, originTopLeft: true)
            while map.valid(coordinate: boxPointer) {
                guard let box = map.item(at: boxPointer) else { break } // we have to know what is here...
                guard box != .wall else { break } // hit a wall, stop scanning...

                if box == .box {
                    boxes.append(boxPointer)
                    boxPointer = boxPointer.moving(direction: move.direction, originTopLeft: true)
                } else if box == .space {
                    spaceCoordinate = boxPointer
                    break // stop scanning we found space to move into
                }
            }

            if let spaceCoordinate {
                // move box(es) and bot

                // move bot first
                map.update(at: botPosition, with: .space)
                botPosition = position // update position
                map.update(at: botPosition, with: .robot)

                // move a box into the space and move until we're back to the bot
                var moveIdx = spaceCoordinate
                var i = 0
                while i < boxes.count {
                    map.update(at: moveIdx, with: .box)
                    moveIdx = moveIdx.moving(direction: move.direction.opposite, originTopLeft: true)

                    if botPosition != moveIdx {
                        // put a space where the box was (unless the bot is already there)
                        map.update(at: moveIdx, with: .space)
                    }

                    i += 1
                }
            }
        }
    }
}
