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
    }

    struct SearchStep {
        let location: Coordinate
        let distance: Int
        let level: Int
        var finished: Bool = false
    }


    /// Determine the shortest path from start to the end.
    func shortestPath(recursive: Bool = false) -> Int {
        var progress = SearchProgress()
        guard start != nil, goal != nil else { return Int.max }

        let stepSortingBlock: (SearchStep, SearchStep) -> Bool = { $0.distance < $1.distance }

        // places to search
        var toSearch = [SearchStep]()
        // routes that worked
        var solutions = [SearchStep]()

        let startingStep = SearchStep(location: start!, distance: 0, level: 0)
        toSearch.append(startingStep)

        while !toSearch.isEmpty {
            toSearch = toSearch.flatMap { bfSearch(step: $0, progress: &progress, recursive: recursive) }

            // remove (and record) any found solutions
            toSearch = toSearch.filter { step -> Bool in
                if step.finished {
                    print("SOLUTION: \(step)")
                    solutions.append(step)
                }

                return !step.finished
            }

            // remove any paths to search with distances more than our current shortest solution
            let currentShortestSolution = solutions.sorted(by: stepSortingBlock).first?.distance ?? Int.max
            toSearch = toSearch.filter { $0.distance < currentShortestSolution }.sorted(by: stepSortingBlock)
        }

        return solutions.sorted(by: stepSortingBlock).first?.distance ?? 0
    }

    /// Use BFS to find shortest path from this location
    private func bfSearch(step: SearchStep, progress: inout SearchProgress, recursive: Bool) -> [SearchStep] {
        if let prevDistance = progress.distance(location: step.location, level: step.level), prevDistance < step.distance {
            return [] // we visited here before on a shorter route
        }

        // record our distance
        progress.record(distance: step.distance, location: step.location, level: step.level)

        // have we hit our goal?
        if goal == step.location {
            if step.level == 0 {
                print("Hit the goal \(step.distance) - level \(step.level)")
                var finalStep = step
                finalStep.finished = true
                return [finalStep]
            } else {
                // print("Hit ZZ but at level \(step.level).")
                return []
            }
        }

        // if we are on a portal, teleport to the other side...
        if let tile = map[step.location], case .portal(name: let name) = tile {
            guard let otherSide = portalConnections[name]?.first(where: { $0 != step.location }) else {
                print("Unable to find other side of the portal: \(name)")
                return []
            }

            // if we are at level 0 and on an outer portal, abort - only if we are recursive
            if isOuter(portal: step.location) && step.level == 0 && recursive {
                // print("Attempted to enter outer portal \(name) on level zero.")
                return []
            }

            // find empty space next to otherSize
            let emptyNeighbors = MoveDirection.allCases.map({ otherSide.location(for: $0) })
                .filter {
                    guard case .empty = map[$0] else { return false }
                    return true
                }

            if let target = emptyNeighbors.first {
                var newLevel = step.level

                if recursive {
                    // TODO: problem here is we are getting negative levels

                    // determine resursive level
                    if isInner(portal: step.location) {
                        // if we are going into an inner portal, add a level
                        newLevel += 1
                        // print("Teleporting: \(name) - adding level from \(step.level) to \(newLevel)")
                    } else if isOuter(portal: step.location) {
                        // if we are going into an outer portal (must be on level > 0), subtract level
                        newLevel -= 1
                        // print("Teleporting: \(name) - removing level from \(step.level) to \(newLevel)")
                    } else {
                        print("Level switch unknown. Portal \(name)... \(step.location) \(otherSide)")
                        print("X: \(minX)..\(maxX), Y: \(minY)..\(maxY)")
                    }
                }

                // double check what is on the other side to prevent flopping
                if let portalDistance = progress.distance(location: target, level: newLevel), portalDistance < step.distance {
                    // print("\tPeered through the portal \(name) on \(step.level) looking to level \(newLevel); someone has been there quicker before...")
                    return []
                }

                return [SearchStep(location: target, distance: step.distance, level: newLevel)]
            } else {
                print("Unable to teleport to \(name)")
            }
        }

        let nextSteps = MoveDirection.allCases.compactMap { dir -> Coordinate? in
            let nextLocation = step.location.location(for: dir)

            if let tile = map[nextLocation] {
                switch tile {
                case .wall:
                    return nil
                default: // empty spaces and portals
                    guard nextLocation != start else { return nil }
                    return nextLocation
                }
            }

            return nil // nothing here
        }

        let nextPaths = nextSteps.map {
            SearchStep(location: $0, distance: step.distance + 1, level: step.level)
        }

        return nextPaths
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
