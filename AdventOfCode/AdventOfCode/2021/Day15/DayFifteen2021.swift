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
    func dijkstrasAlgo(grid: GridMap<Int>, trackPath: Bool = false) -> CaveNode? {
        guard let xMax = grid.xBounds.max(), let yMax = grid.yBounds.max() else { return nil } // TODO: check this...

        let origin = Coordinate(x: 0, y: 0)
        let destination = Coordinate(x: xMax, y: yMax)

        var nodeMap = [Coordinate: CaveNode]()
        grid.coordinates().forEach { c in
            guard let value = grid.item(at: c) else { return }
            let node = CaveNode(location: c, cost: value, trackPath: trackPath)
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
                guard let node = nodeMap[c] else { return }

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

    func dijkstrasAlgoV2(grid: GridMap<Int>, multiplier: Int = 1) -> Int {
        let maxX = ((grid.xBounds.upperBound * multiplier) - 1)
        let maxY = ((grid.yBounds.upperBound * multiplier) - 1)

        let origin = Coordinate(x: 0, y: 0)
        let destination = Coordinate(x: maxX, y: maxY)

        let xBounds = 0...maxX
        let yBounds = 0...maxY

        var costMap = [Coordinate: Int]()

        let coordinates = yBounds.flatMap { y -> [Coordinate] in
            xBounds.map { x -> Coordinate in
                let c = Coordinate(x: x, y: y)
                costMap[c] = Int.max
                return c
            }
        }

        var toVisit = Set<Coordinate>(coordinates)

        costMap[origin] = 0

        while !toVisit.isEmpty {
            // grab the node with the current shortest distance to visit first
            guard let visiting = toVisit.min(by: { (costMap[$0] ?? Int.max) < (costMap[$1] ?? Int.max) }) else { continue }
            toVisit.remove(visiting)

            if visiting == destination {
                break
            }

            let currentCost = costMap[visiting] ?? Int.max

            let neighbors = Set(visiting.adjacentWithoutDiagonals(xBounds: xBounds, yBounds: yBounds)).intersection(toVisit)
            neighbors.forEach { c in
                let newCost = currentCost + nodeCost(grid: grid, coordinate: c)
                if newCost < (costMap[c] ?? Int.max) {
                    costMap[c] = newCost
                }
            }
        }

        return costMap[destination] ?? Int.max
    }

    /// Calculate the value at a given node (ie: "cost") of the grid given a much larger scale...
    func nodeCost(grid: GridMap<Int>, coordinate: Coordinate) -> Int {
        let xSize = grid.xBounds.upperBound
        let ySize = grid.yBounds.upperBound

        let yDistance = coordinate.y / ySize
        let xDistance = coordinate.x / xSize

        let readY = coordinate.y % ySize
        let readX = coordinate.x % xSize

        let ogValue = grid.itemAt(x: readX, y: readY) ?? 0

        var newValue = (ogValue + (yDistance + xDistance)) % 9
        if newValue == 0 {
            newValue = 9
        }
        return newValue
    }

    func partOne(input: String?) -> Any {
        let grid = parse(input)
        grid.printSize()
        print("Start: \(Date())")
        let finalNode = dijkstrasAlgo(grid: grid)
        print(finalNode!)
        print("End: \(Date())")
        return finalNode?.minDistance ?? 0
    }

    func partTwo(input: String?) -> Any {
        let grid = parse(input)
        grid.printSize()
        print("Start: \(Date())")
        let cost = dijkstrasAlgoV2(grid: grid, multiplier: 5)
        print("End: \(Date())")
        return cost
    }
}
