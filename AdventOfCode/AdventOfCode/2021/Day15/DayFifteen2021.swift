//
//  DayFifteen2021.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/15/21.
//

import Foundation

struct DayFifteen2021: AdventDay {
    var year = 2021
    var dayNumber = 15
    var dayTitle = "Chiton"
    var stars = 1

    func parse(_ input: String?) -> GridMap<Int> {
        let data: [[Int]] = (input ?? "").split(separator: "\n").map(String.init).map { $0.map(String.init).compactMap(Int.init) }
        return GridMap<Int>(items: data)
    }

    /// Use Dijkstra's Algorithm to find the shortest path from the origin (0,0) to the end (bottom right node)
    ///
    /// - return: `CaveNode` for the final node which should include minium cost and path
    func dijkstrasAlgo(grid: GridMap<Int>) -> CaveNode? {
        guard let xMax = grid.xBounds.max(), let yMax = grid.yBounds.max() else { return nil } // TODO: check this...

        let origin = Coordinate(x: 0, y: 0)
        let destination = Coordinate(x: xMax, y: yMax)
        print("Starting at \(origin) and heading towards \(destination)...")

        var nodeMap = [Coordinate: CaveNode]()
        grid.coordinates().forEach { c in
            guard let value = grid.item(at: c) else { return }
            let node = CaveNode(location: c, cost: value)
            nodeMap[c] = node
        }

        // create visited and unvisited sets
        var unvisitedLocations = Set<Coordinate>(grid.coordinates())
        var visitedLocations = Set<Coordinate>()

        // setup origin node
        unvisitedLocations.remove(origin)
        if let originNode = nodeMap[origin] {
            originNode.update(distance: 0, path: [])
            originNode.minDistance = 0 // force to 0 since we shouldn't count the cost of this node
            print(originNode)
        }

        var workingLocations: [Coordinate] = [origin]

        // start up the machine...
        while !workingLocations.isEmpty {
            var locationsToVisitNext = [Coordinate]()

            // for each working node, consider it's unvisited adjacent coordinates
            workingLocations.forEach { c in
//                print("Visiting \(c)")
                guard let node = nodeMap[c] else { return }
//                print("\tNode: \(node)")

                let adjacent = Set(grid.adjacentCoordinates(to: c, allowDiagonals: false))
                let unvisitedAdjacent = adjacent.subtracting(visitedLocations)
                unvisitedAdjacent.forEach { coord in
                    guard let unvisitedNode = nodeMap[coord] else { return }
                    unvisitedNode.update(distance: node.minDistance, path: node.shortedPath)
                    locationsToVisitNext.append(coord)
                }

                visitedLocations.insert(c)
            }

            // update working locations
            workingLocations = locationsToVisitNext.unique()
        }

        return nodeMap[destination]
    }

    func partOne(input: String?) -> Any {
        let grid = parse(input)
        print("Start: \(Date())")
        let finalNode = dijkstrasAlgo(grid: grid)
        print(finalNode)
        print("End: \(Date())")
        return finalNode?.minDistance ?? 0
    }

    func partTwo(input: String?) -> Any {
        return Int.min
    }
}
