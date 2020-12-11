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
