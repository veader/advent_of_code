//
//  GardenPlots.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/12/24.
//

import Foundation

class GardenPlots {
    let map: GridMap<String>

    var plants: [String: Set<Coordinate>] = [:]

    init(map: GridMap<String>) {
        self.map = map

        findPlants()
    }

    /// Create a mapping of all the different plant types and where they are.
    func findPlants() {
        var tmpPlants: [String: Set<Coordinate>] = [:]
        map.iterate { c, v in
            var set = tmpPlants[v] ?? Set()
            set.insert(c)
            tmpPlants[v] = set
        }

        plants = tmpPlants
    }

    /// Find all the different regions of the given plant.
    func findRegionsFor(plant: String) -> [[Coordinate]] {
        var thesePlants: Set<Coordinate> = plants[plant] ?? []
        var regions: [[Coordinate]] = []

        while !thesePlants.isEmpty {
            guard let start = thesePlants.first else {
                print("Unable to find a starting plant? \(thesePlants)")
                return []
            }

            guard let region = findRegion(plant: plant, starting: start) else {
                print("Unable to find region of \(plant) starting from \(start). \(thesePlants)")
                return []
            }

            thesePlants.subtract(region)
            regions.append(region.map(\.self))
        }

        return regions
    }

    /// Find the region of the given plant starting with the given coordinate.
    func findRegion(plant: String, starting origin: Coordinate) -> Set<Coordinate>? {
        var placesToLook: Set<Coordinate> = [origin]
        var visited: Set<Coordinate> = []

        while !placesToLook.isEmpty {
            let plantHere = placesToLook.removeFirst()
            visited.insert(plantHere)

            /// find any adjacent (unvisited) matching plants
            map.adjacentCoordinates(to: plantHere, allowDiagonals: false).forEach { c in
                guard let v = map.item(at: c), v == plant, !visited.contains(c) else { return }
                placesToLook.insert(c)
            }
        }

        guard !visited.isEmpty else { return nil }
        return visited
    }

    /// Calculate the costs for a given region. Area * Fences
    func calculateCostFor(region: [Coordinate]) -> Int {
        var fences = 0
        for c in region {
            let adjacent = map.adjacentCoordinates(to: c, allowDiagonals: false)
            // add the number of sides *NOT* touching something in our region
            let adjacentToCount = adjacent.filter { !region.contains($0) }
            // if along the edges, we don't have all 4 adjacent values, add those back...
            let correction = 4 - adjacent.count
            fences += adjacentToCount.count + correction
        }

        let area = region.count
        return area * fences
    }

    /// Calculate the total cost for the garden based on plants/regions within.
    func calculateCosts() -> Int {
        var cost = 0

        for plant in plants.keys {
            let regions = findRegionsFor(plant: plant)
            cost += regions.reduce(0) { $0 + calculateCostFor(region: $1) }
        }

        return cost
    }


    // MARK: - Part Two

    struct FenceSegment {
        enum FenceSide: CaseIterable {
            case top
            case bottom
            case left
            case right
        }

        let location: Coordinate
        let side: FenceSide
    }

    // IDEA: find region by following boundary edge. Accumulating continguous sides
    // and coordiantes within the region. Sort coordinates available (for plant) and
    // start at the "least" one (closest to origin) looking at the top until we exit
    // the region, then turn 90º and continue around the perimeter.

    func calculateBulkCostFor(region: [Coordinate]) -> Int {
        var sides: [FenceSegment] = []
        for c in region {
            for side in FenceSegment.FenceSide.allCases {
                if let segment = examine(side: side, of: c) {
                    sides.append(segment)
                }
            }
        }

        // TODO: find contiguous segments within sides...

        return 0
    }

    /// Examine the side of the given coordinate in the region to determine it needs a fence segment.
    func examine(side: FenceSegment.FenceSide, of coordinate: Coordinate) -> FenceSegment? {
        guard let thisItem = map.item(at: coordinate) else { return nil }

        var direction: Coordinate.RelativeDirection = .north
        switch side {
        case .top:
            direction = .north
        case .bottom:
            direction = .south
        case .left:
            direction = .west
        case .right:
            direction = .east
        }

        let inDirection = coordinate.moving(direction: direction, originTopLeft: true)

        // if coordinate is off the grid, it is a side of the region
        // if the value at does not match, it is a side of the region
        guard let item = map.item(at: inDirection), item != thisItem else { return nil }
        return FenceSegment(location: coordinate, side: side)
    }
}
