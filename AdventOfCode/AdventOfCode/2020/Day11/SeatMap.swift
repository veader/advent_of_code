//
//  SeatMap.swift
//  aoc2020
//
//  Created by Shawn Veader on 12/11/20.
//

import Foundation

struct SeatMap: Equatable {
    enum Space: String {
        case floor = "."
        case emptySeat = "L"
        case occupiedSeat = "#"
    }

    enum Slope: CaseIterable {
        case upLeft
        case up
        case upRight
        case right
        case downRight
        case down
        case downLeft
        case left

        var rise: Int {
            switch self {
            case .up, .upLeft, .upRight:
                return -1
            case .left, .right:
                return 0
            case .down, .downLeft, .downRight:
                return 1
            }
        }

        var run: Int {
            switch self {
            case .upLeft, .left, .downLeft:
                return -1
            case .up, .down:
                return 0
            case .upRight, .right, .downRight:
                return 1
            }
        }
    }

    let map: [[Space]]

    var rows: Int {
        map.count
    }

    var columns: Int {
        map.first?.count ?? 0
    }

    var occupiedSeats: Int {
        map.reduce(0) { (rowResult, row) -> Int in
            rowResult + row.reduce(0) { (result, space) -> Int in
                if case .occupiedSeat = space {
                    return result + 1
                } else {
                    return result
                }
            }
        }
    }

    func spaceAt(x: Int, y: Int) -> Space? {
        guard map.indices.contains(y) else { return nil }
        let row = map[y]
        guard row.indices.contains(x) else { return nil }
        return row[x]
    }

    func nearbyOccupiedSeats(x xCoord: Int, y yCoord: Int) -> Int {
        (yCoord-1...yCoord+1).reduce(0) { (result, y) -> Int in
            guard map.indices.contains(y) else { return result } // out of bounds
            let row = map[y]

            return result + (xCoord-1...xCoord+1).reduce(0) { (rowResult, x) -> Int in
                guard
                    row.indices.contains(x), // out of bounds
                    !(xCoord == x && yCoord == y), // ignore the actual space itself
                    let space = spaceAt(x: x, y: y),
                    case .occupiedSeat = space
                    else { return rowResult }

                return rowResult + 1
            }
        }
    }

    func visibleOccupiedSeats(x: Int, y: Int) -> Int {
        Slope.allCases.reduce(0) { (result, slope) -> Int in
            guard let answer = visibleSeat(x: x, y: y, slope: slope) else { return result }
            if case .occupiedSeat = answer.space {
                return result + 1
            } else {
                return result
            }
        }
    }

    /// Look along the given slope from the given coordinate and find the first non-floor space (if any)
    func visibleSeat(x: Int, y: Int, slope: Slope) -> (space: Space, x: Int, y: Int)? {
        var offsetX = x + slope.run
        var offsetY = y + slope.rise
        var nextSpace = spaceAt(x: offsetX, y: offsetY)

        while nextSpace != nil, case .floor = nextSpace {
            // print("Looked @ (\(offsetX),\(offsetY))")
            offsetX += slope.run
            offsetY += slope.rise
            nextSpace = spaceAt(x: offsetX, y: offsetY)
        }

        // print("Found something @ (\(offsetX),\(offsetY))")

        if let space = nextSpace {
            return (space, offsetX, offsetY)
        } else {
            return nil
        }
    }
}

extension SeatMap {
    init?(_ input: String?) {
        guard let input = input else { return nil }

        map = input.split(separator: "\n").map(String.init).map { line -> [Space] in
            line.map(String.init).compactMap { Space.init(rawValue: $0) }
        }

        // confirm the map is all a consistent width
        guard map.map({ $0.count }).unique().count == 1 else {
            print("ERROR: Map width inconsistent...")
            return nil
        }
    }
}

extension SeatMap: CustomDebugStringConvertible {
    var debugDescription: String {
        map.map { row -> String in
            row.map({ $0.rawValue }).joined()
        }.joined(separator: "\n")
    }
}
