//
//  DonutMaze.swift
//  aoc2019
//
//  Created by Shawn Veader on 12/20/19.
//  Copyright © 2019 Shawn Veader. All rights reserved.
//

import Foundation

struct DonutMaze {
    enum MazeTile {
        case wall
        case empty
        case portal(name: String)
    }

    /// Grid map of donut maze
    let map: [Coordinate: MazeTile]

    /// Starting location (empty tile beside AA)
    let start: Coordinate?

    /// End/goal location (empty tile beside ZZ)
    let goal: Coordinate?

    /// Connections between portals. Stored by name with in/out coordinates
    let portalConnections: [String: [Coordinate]]

    init(input: String) {
        var tmpStart: Coordinate? = nil
        var tmpGoal: Coordinate? = nil

        var tmpMap = [Coordinate: MazeTile]()

        var portalLetters = [Coordinate: String]() // individual letters
        var portalNames = [String: [Coordinate]]() // portal names (both letters)

        // first, build maze map with walls and spaces. record portal values along the way
        for (y, line) in input.split(separator: "\n").map(String.init).enumerated() {
            for (x, char) in line.enumerated() {
                let str = String(char)
                let location = Coordinate(x: x, y: y)

                switch str {
                case " ":
                    break
                case "#":
                    tmpMap[location] = .wall
                case ".":
                    tmpMap[location] = .empty
                default:
                    if char.isLetter {
                        portalLetters[location] = str
                    }
                }
            }
        }

        let coordSorting: (Coordinate, Coordinate) -> Bool = { (c1, c2) -> Bool in
            c1.y < c2.y || c1.x < c2.x
        }

        // next, find portal names and pairings
        for location in portalLetters.keys.sorted(by: coordSorting) {
            // portal location exist for a letter that is beside another
            //  letter AND an empty space
            let neighborLetters = MoveDirection.allCases.compactMap { dir -> Coordinate? in
                let near = location.location(for: dir)
                guard portalLetters[near] != nil else { return nil }
                return near
            }

            let emptyLocations = MoveDirection.allCases.compactMap { dir -> Coordinate? in
                let near = location.location(for: dir)
                guard case .empty = tmpMap[near] else { return nil }
                return near
            }

            if neighborLetters.count == 1 && emptyLocations.count == 1{
                let name = [location, neighborLetters.first!]
                                    .sorted(by: coordSorting)
                                    .compactMap { portalLetters[$0] }
                                    .joined()
                guard name.count == 2 else {
                    print("Huh... only found 1 letter @ \(location)")
                    continue
                }

                if name == "AA" {
                    tmpStart = emptyLocations.first
                } else if name == "ZZ" {
                    tmpGoal = emptyLocations.first
                } else {
                    portalNames[name] = (portalNames[name] ?? []) + [location]
                    tmpMap[location] = .portal(name: name)
                }
            }
        }

        map = tmpMap
        portalConnections = portalNames
        start = tmpStart
        goal = tmpGoal
    }

    /// Determine the shortest path from start to the end.
    func shortestPath() -> Int {
        var distanceMap = [Coordinate: Int]()
        guard start != nil, goal != nil else { return Int.max }

        return bfSearch(location: start!, distance: 0, progress: &distanceMap)
    }

    /// Use BFS to find shortest path from this location
    private func bfSearch(location: Coordinate, distance: Int, progress distanceMap: inout [Coordinate: Int]) -> Int {
        if let prevDistance = distanceMap[location], prevDistance < distance {
            return Int.max // we visited here before on a shorter route
        }

        distanceMap[location] = distance

        // have we hit our goal?
        if goal == location {
            print("Hit the goal \(distance)")
            return distance
        }

        // if we are on a portal, teleport to the other side...
        if let tile = map[location], case .portal(name: let name) = tile {
            guard let otherSide = portalConnections[name]?.first(where: { $0 != location }) else {
                print("Unable to find other side of the portal: \(name)")
                return Int.max
            }

            // find empty space next to otherSize
            let neighbors = MoveDirection.allCases.map({ otherSide.location(for: $0) })
            if let target = neighbors.first(where: {
                if case .empty = map[$0] {
                    return true
                }
                return false
            }) {
                print("Teleporting: \(name)")
                return bfSearch(location: target, distance: distance, progress: &distanceMap)
            } else {
                print("Unable to teleport to \(name)")
            }
        }

        let nextSteps = MoveDirection.allCases.compactMap { dir -> Coordinate? in
            let nextLocation = location.location(for: dir)

            if let tile = map[nextLocation] {
                switch tile {
                case .wall:
                    return nil
                default:
                    return nextLocation
                }
            }

            return nil // nothing here
        }

        let shortestPaths = nextSteps.map {
            bfSearch(location: $0, distance: distance + 1, progress: &distanceMap)
        }

        return shortestPaths.min() ?? Int.max
    }
}
