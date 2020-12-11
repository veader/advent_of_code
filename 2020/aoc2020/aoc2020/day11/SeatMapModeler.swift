//
//  SeatMapModeler.swift
//  aoc2020
//
//  Created by Shawn Veader on 12/11/20.
//

import Foundation

class SeatMapModeler {
    var map: SeatMap

    init(map: SeatMap) {
        self.map = map
    }

    func findFinalGeneration() -> SeatMap {
        var interimMap = map
        var nextGen = nextGeneration(map: interimMap)
        var count = 1

        repeat {
            print("Generations: \(count)...")
            interimMap = nextGen
            nextGen = nextGeneration(map: interimMap)
            count += 1
        } while nextGen != interimMap

        return interimMap
    }

    /// Generate a new map based on the following rules:
    ///
    /// - If a seat is empty (L) and there are no occupied seats adjacent to it, the seat becomes occupied.
    /// - If a seat is occupied (#) and four or more seats adjacent to it are also occupied, the seat becomes empty.
    func nextGeneration(map theMap: SeatMap) -> SeatMap {
        var newMap = theMap.map

        for (y, row) in newMap.enumerated() {
            for (x, space) in row.enumerated() {
                switch space {
                case .floor:
                    continue // do nothing
                case .emptySeat:
                    if theMap.nearbyOccupiedSeats(x: x, y: y) == 0 {
                        newMap[y][x] = .occupiedSeat
                    }
                case .occupiedSeat:
                    if theMap.nearbyOccupiedSeats(x: x, y: y) >= 4 {
                        newMap[y][x] = .emptySeat
                    }
                }
            }
        }

        return SeatMap(map: newMap)
    }
}
