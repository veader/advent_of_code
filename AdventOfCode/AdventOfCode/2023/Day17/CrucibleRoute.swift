//
//  CrucibleRoute.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/19/23.
//

import Foundation

class CrucibleRoute {
    let data: GridMap<Int>
    let destination: Coordinate

    enum CrucibleRouteError: Error {
        case badGridBounds
    }

    init(data: GridMap<Int>) {
        self.data = data
        destination = Coordinate(x: data.xBounds.upperBound-1, y: data.yBounds.upperBound-1)
    }

    struct PathComponent: Equatable {
        let location: Coordinate
        let direction: Coordinate.RelativeDirection
    }


    /// Use Dijkstra's Algorithm to find the shortest path from the origin (0,0) to the end (bottom right node)
    func calculateRoute(trackPath: Bool = true) throws -> CityBlock? {
        var blockMap = [Coordinate: CityBlock]()

        // build "blank" state of solution space
        data.coordinates().forEach { c in
            guard let value = data.item(at: c) else { return }
            let block = CityBlock(location: c, cost: value, trackPath: trackPath)
            blockMap[c] = block
        }

        // create visited and unvisited sets
        var unvisitedLocations = Set<Coordinate>(data.coordinates())
        var visitedLocations = Set<Coordinate>()

        // setup origin node
        unvisitedLocations.remove(Coordinate.origin)
        if let originBlock = blockMap[Coordinate.origin] {
            _ = originBlock.update(distance: 0, path: [])
            originBlock.minDistance = 0 // force to 0 since we shouldn't count the cost of this node
            // print(originBlock)
        }

        var workingLocations: [Coordinate] = [Coordinate.origin]

        // start up the machine...
        while !workingLocations.isEmpty {
            var locationsToVisitNext = [Coordinate]()

            // for each working location, consider it's unvisited adjacent coordinates
            workingLocations.forEach { c in
                guard let block = blockMap[c] else { return }
                print("Considering \(c) -> \(block.cost) / \(block.minDistance) -> \(block.shortedPath.count)...")

                let straightLimit = 3
                let suffix = block.shortedPath.suffix(straightLimit)
                let xs = suffix.map(\.x).unique()
                let ys = suffix.map(\.y).unique()
                
                let adjacent = Set(data.adjacentCoordinates(to: c, allowDiagonals: false))
                 let unvisitedAdjacent = adjacent.subtracting(visitedLocations)
//                let unvisitedAdjacent = adjacent.subtracting(Set(block.shortedPath))
                unvisitedAdjacent.forEach { coord in
                    print("\tAdjacent: \(coord)")
                    guard let unvisitedBlock = blockMap[coord] else { return }

                    if suffix.count == straightLimit { // we need at least this many to do the check
                        // we are going "straight" if either the x or y hasn't changed
                        if xs.count == 1, xs.first == unvisitedBlock.location.x {
                            return
                        } else if ys.count == 1, ys.first == unvisitedBlock.location.y {
                            return
                        }
                    }

                    if unvisitedBlock.update(distance: block.minDistance, path: block.shortedPath) {
                        locationsToVisitNext.append(coord)
                    }
                }

                visitedLocations.insert(c)
            }

            // update working locations
            workingLocations = locationsToVisitNext.unique()
        }

        print("-----------------------------------------")
        data.coordinates().forEach { c in
            guard let block = blockMap[c] else { print("No block at \(c)"); return }
            print("\(c.x)x\(c.y) @ (\(block.cost)) - \(block.minDistance) : \(block.shortedPath.suffix(5)) (\(block.shortedPath.count))")
        }
        print("-----------------------------------------")

        return blockMap[destination]
    }


    // MARK: -

//    func calculateLeastHeatLost() async -> Int {
//        let heatLostAmounts = await withTaskGroup(of: Int.self) { group in
//            var amounts = [Int]()
//
//            group.addTask {
//                return await self.calculateRoute1(from: .origin, moving: .east, along: [PathComponent(location: .origin, direction: .east)], heatLost: 0)
//            }
//
//            group.addTask {
//                return await self.calculateRoute1(from: .origin, moving: .south, along: [PathComponent(location: .origin, direction: .south)], heatLost: 0)
//            }
//
//            for await amount in group {
//                amounts.append(amount)
//            }
//            
//            return amounts
//        }
//
//        return heatLostAmounts.min() ?? Int.max
//        
////        await calculateRoute1(from: .origin, moving: .east, along: [PathComponent(location: .origin, direction: .east)], heatLost: 0)
//    }
//
//    func calculateRoute1(from location: Coordinate, moving direction: Coordinate.RelativeDirection, along path: [PathComponent], heatLost: Int) async -> Int {
//        // find possible next steps
//        let possible = possibleRoutes(from: location, moving: direction, along: path)
//
////        let output = """
////            @ \(location.x)x\(location.y) | going: \(direction) | heat: \(heatLost)
////            \tPath:
////            \(path.map({ "\t\t\($0)" }).joined(separator: "\n"))
////            \tPossible Routes:
////            \(possible.map({ "\t\t\($0)" }).joined(separator: "\n"))
////            """
////        print(output)
//
//
//        let possibleAmounts = await withTaskGroup(of: Int.self) { group in
//            var amounts = [Int]()
//
//            for route in possible {
//                // check for destination
//                if route.location == destination {
//                    let heat = self.data.item(at: route.location) ?? Int.max
//                    amounts.append(heatLost + heat)
//                    print("Found end of the line...")
//                    print(path + [route])
//                    print("Heat lost: \(heatLost + heat)")
//                    print("-------------------------------------------------")
//                } else {
//                    // continue the search
//                    group.addTask {
//                        let heat = self.data.item(at: route.location) ?? Int.max
//                        return await self.calculateRoute1(from: route.location, moving: route.direction, along: path + [route], heatLost: heatLost + heat)
//                    }
//                }
//            }
//
//            for await amount in group {
//                amounts.append(amount)
//            }
//
//            return amounts
//        }
//        
//        // create group & add tasks for each next step
//        // add heat from that step as you take it
//        return possibleAmounts.min() ?? Int.max
//    }
//
//    func possibleRoutes(from location: Coordinate, moving: Coordinate.RelativeDirection, along path: [PathComponent]) -> [PathComponent] {
//        var possibleDirections = [Coordinate.RelativeDirection]()
//
//        let adjacent = data.adjacentCoordinates(to: location)
//        // remove the path backwards path?
//
//        let coordinates = path.map(\.location)
//
//        let paths: [PathComponent] = possibleDirections.compactMap { direction in
//            if direction == moving {
//                // make sure we haven't moved 3 in this direction yet
//                guard path.suffix(3).filter({$0.direction == direction}).count != 3 else { return nil }
//            }
//
//            // determine if we *can* move in this direction (edge of map check)
//            // make sure we don't cross the same point twice
//            let c = location.moving(direction: direction, originTopLeft: true)
//            guard data.valid(coordinate: c), !coordinates.contains(c) else { return nil }
//            return PathComponent(location: c, direction: direction)
//        }
//
//        return paths
//    }
}
