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

    var portals: [Coordinate] {
        map.compactMap { (coord, tile) -> Coordinate? in
            guard case .portal(name: _) = tile else { return nil }
            return coord
        }
    }
    
    var minX: Int {
        map.keys.min(by: { $0.x < $1.x })?.x ?? 0
    }

    var maxX: Int {
        map.keys.max(by: { $0.x < $1.x })?.x ?? 0
    }

    var minY: Int {
        map.keys.min(by: { $0.y < $1.y })?.y ?? 0
    }

    var maxY: Int {
        map.keys.max(by: { $0.y < $1.y })?.y ?? 0
    }


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


    // MARK: - Searching

    struct SearchProgress {
        // hash by recursion level, then by coordinate to distance
        var distanceMap = [Int: [Coordinate: Int]]()

        // hashed by portal name and recursion levels used on
        var usedPortals = [String: [Int]]()

        func distance(location: Coordinate, level: Int) -> Int? {
            guard
                let levelMap = distanceMap[level],
                let distance = levelMap[location]
                else { return nil }

            return distance
        }

        mutating func record(distance: Int, location: Coordinate, level: Int) {
            if var levelMap = distanceMap[level] {
                levelMap[location] = distance
                distanceMap[level] = levelMap // just in case
            } else {
                var newMap = [Coordinate: Int]()
                newMap[location] = distance
                distanceMap[level] = newMap
            }
        }

        func wasUsed(portal: String, level: Int) -> Bool {
            guard let levels = usedPortals[portal], levels.contains(level) else { return false }
            return true
        }

        mutating func markUsed(level: Int, portal: String) {
            usedPortals[portal] = (usedPortals[portal] ?? []) + [level]
        }

        mutating func removeUsedMark(level: Int, portal: String) {
            usedPortals[portal] = (usedPortals[portal] ?? []).filter { $0 != level}
        }
    }


    /// Determine the shortest path from start to the end.
    func shortestPath(recursive: Bool = false) -> Int {
        var progress = SearchProgress()
        guard start != nil, goal != nil else { return Int.max }

        return bfSearch(location: start!, distance: 0, level: 0, progress: &progress, recursive: recursive)
    }

    /// Use BFS to find shortest path from this location
    private func bfSearch(location: Coordinate, distance: Int, level: Int, progress: inout SearchProgress, recursive: Bool) -> Int {
        if let prevDistance = progress.distance(location: location, level: level), prevDistance < distance {
            return Int.max // we visited here before on a shorter route
        }

        // record our distance
        progress.record(distance: distance, location: location, level: level)

        // have we hit our goal?
        if goal == location {
            if level == 0 {
                print("Hit the goal \(distance) - level \(level)")
                return distance
            } else {
                print("Hit ZZ but at level \(level)")
                return Int.max
            }
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
                var newLevel = level

                var debugText = ""

                if recursive {
                    // TODO: we might have to care about level + coordinate


                    // before we step into a portal, see if has been used on
                    //  this level before. if so, we need to pop levels; otherwise push
                    if progress.wasUsed(portal: name, level: level) {
                        newLevel = max(0, level - 1) // used portal mean we are going down
                        debugText = "Popping a level entering used \(name) on \(level) -> \(newLevel)"

                        // clear mark as we go down
                        progress.removeUsedMark(level: level, portal: name)
                    } else {
                        newLevel = level + 1 // unused portal means we we are going up
                        debugText = "Pushing a level entering \(name) on \(level) -> \(newLevel)"

                        // mark the next level up so we know how to get down
                        progress.markUsed(level: newLevel, portal: name)
                    }


                    // TODO: problem here is we are getting negative levels

                    /*
                    // determine resursive
                    if isInner(portal: location) && isOuter(portal: otherSide) {
                        // popping a level
                        newLevel -= 1
                        print("Teleporting: \(name) - popping level from \(level) to \(newLevel)")
                    } else if isInner(portal: otherSide) && isOuter(portal: location) {
                        // pushing on a level
                        newLevel += 1
                        print("Teleporting: \(name) - pushing level from \(level) to \(newLevel)")
                    } else {
                        print("Level switch unknown. Portal \(name)... \(location) \(otherSide)")
                        print("X: \(minX)..\(maxX), Y: \(minY)..\(maxY)")
                    }
                     */

                    // mark this portal as closed on both sides
//                    progress.markUsed(level: level, portal: name)
//                    progress.markUsed(level: newLevel, portal: name)
//                    print(progress.usedPortals)
                }

                // double check what is on the other side to prevent flopping
                if let portalDistance = progress.distance(location: target, level: newLevel), portalDistance < distance {
                    print("\tPeered through the portal \(name) on \(level) looking to level \(newLevel); someone has been there quicker before...")
                    return Int.max
                }

                if !debugText.isEmpty {
                    print(debugText)
                }

                return bfSearch(location: target, distance: distance, level: newLevel, progress: &progress, recursive: recursive)
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
//                case .portal(name: let name):
//                    if progress.wasUsed(portal: name, level: level) {
//                        print("Hit used portal \(name)")
//                        return nil
//                    } else {
//                        return nextLocation
//                    }
                default: // empty spaces and portals
                    guard nextLocation != start else { return nil }
                    return nextLocation
                }
            }

            return nil // nothing here
        }

        let shortestPaths = nextSteps.map {
            bfSearch(location: $0, distance: distance + 1, level: level, progress: &progress, recursive: recursive)
        }

        return shortestPaths.min() ?? Int.max
    }


    // MARK: - Helpers
    func isInner(portal: Coordinate) -> Bool {
        portal.x != minX && portal.y != minY &&
        portal.x != maxX && portal.y != maxY
    }

    func isOuter(portal: Coordinate) -> Bool {
        portal.x == minX || portal.y == minY ||
        portal.x == maxX || portal.y == maxY
    }
}
