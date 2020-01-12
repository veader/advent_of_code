//
//  Vault.swift
//  aoc2019
//
//  Created by Shawn Veader on 12/18/19.
//  Copyright © 2019 Shawn Veader. All rights reserved.
//

import Foundation

struct Vault {
    enum GridType {
        case wall
        case empty
        case start
        case door(name: String)
        case key(name: String)
    }

    let map: [Coordinate: GridType]
    let keys: [String]
    let doors: [String]
    var startLocation: Coordinate?

    // MARK: - Init & Parsing
    init(input: String) {
        print(input)

        var tmpMap = [Coordinate: GridType]()
        var tmpKeys = [String]()
        var tmpDoors = [String]()

        let lines = input.split(separator: "\n").map(String.init)
        var y = 0
        for line in lines {
            for (x, value) in line.map(String.init).enumerated() {
                var gridType: GridType?
                let location = Coordinate(x: x, y: y)

                switch value {
                case "#":
                    gridType = .wall
                case ".":
                    gridType = .empty
                case "@":
                    gridType = .start
                    startLocation = location
                default:
                    if let scaler = UnicodeScalar(value),
                        CharacterSet.letters.contains(scaler) {

                        if value.uppercased() == value {
                            gridType = .door(name: value)
                            tmpDoors.append(value)
                        } else {
                            gridType = .key(name: value)
                            tmpKeys.append(value)
                        }
                    } else {
                        print("Not sure what '\(value)' is...")
                    }
                }

                if let gridType = gridType {
                    tmpMap[location] = gridType
                }
            }

            y += 1
        }

        map = tmpMap
        keys = tmpKeys.sorted()
        doors = tmpDoors
    }

    func pruneMap() -> String {
        var fixedLocations = true

        var fixedMap = map // mutable copy

        let usedCoordinates = map.keys
        let minX = usedCoordinates.min(by: { $0.x < $1.x })?.x ?? 0
        let maxX = usedCoordinates.max(by: { $0.x < $1.x })?.x ?? 0
        let minY = usedCoordinates.min(by: { $0.y < $1.y })?.y ?? 0
        let maxY = usedCoordinates.max(by: { $0.y < $1.y })?.y ?? 0

        let xRange = min(0, minX)..<(maxX + 1)
        let yRange = min(0, minY)..<(maxY + 1)

        var iteration = 0

        while fixedLocations {
            iteration += 1
            fixedLocations = false // start fresh

            // go through each coordinate and if it has 3 walls surrounding it, make it a wall
            for y in yRange {
                for x in xRange {
                    let location = Coordinate(x: x, y: y)
                    guard case .empty = fixedMap[location] else { continue } // only touching empty spaces

                    let walls = location.adjacent().compactMap { location -> GridType? in
                        guard case .wall = fixedMap[location] else { return nil }
                        return fixedMap[location]
                    }

                    if walls.count >= 3 {
                        fixedMap[location] = .wall
                        fixedLocations = true
                    }
                }
            }
        }

        var output = ""
        for y in yRange {
            for x in xRange {
                let location = Coordinate(x: x, y: y)
                switch fixedMap[location] {
                case .empty:
                    output += "."
                case .start:
                    output += "@"
                case .wall:
                    output += "#"
                case .key(name: let key):
                    output += key
                case .door(name: let door):
                    output += door
                case .none:
                    break
                }
            }
            output += "\n"
        }
        return output
    }


    class SearchProgress {
        var distanceMap = [Coordinate: [String: SearchStep]]()
    }

    struct SearchStep: Equatable {
        let location: Coordinate
        let foundKeys: [String]
        let stepCount: Int

        var hashKey: String {
            foundKeys.joined(separator: ",")
        }

        /// Can we unlock a given door with our found keys?
        func canUnlock(door: String) -> Bool {
            foundKeys.contains(door.lowercased())
        }

        /// Pick up a given key (if we haven't already) and return a new SearchStep
        func pickup(key: String) -> SearchStep {
            guard !foundKeys.contains(key) else { return self }

            var newFoundKeys = foundKeys
            newFoundKeys.append(key)
            newFoundKeys = newFoundKeys.sorted()

            return SearchStep(location: location, foundKeys: newFoundKeys, stepCount: stepCount)
        }

        /// Update the location and increment the step count in new SearchStep
        func move(to newLocation: Coordinate) -> SearchStep {
            return SearchStep(location: newLocation, foundKeys: foundKeys, stepCount: stepCount + 1)
        }

        static func ==(lhs: SearchStep, rhs: SearchStep) -> Bool {
            return  lhs.location == rhs.location &&
                    lhs.stepCount == rhs.stepCount &&
                    lhs.foundKeys.sorted() == rhs.foundKeys.sorted()
        }
    }

    func shortestPathToAllKeys() -> SearchStep? {
        var progress = SearchProgress()
        let sortedKeys = keys.sorted()
        let stepSortingBlock: (SearchStep, SearchStep) -> Bool = { $0.stepCount < $1.stepCount }

        // places to search
        var toSearch = [SearchStep]()
        // routes that worked
        var solutions = [SearchStep]()

        let startingStep = SearchStep(location: startLocation!, foundKeys: [], stepCount: 0)
        toSearch.append(startingStep)

        var iteration = 0

        while !toSearch.isEmpty {
            toSearch = toSearch.flatMap { bfSearch(step: $0, progress: &progress) }

            // remove (and record) any found solutions
            toSearch = toSearch.filter { step -> Bool in
                if step.foundKeys == sortedKeys {
                    if !solutions.contains(step) {
                        print("SOLUTION: \(step)")
                        solutions.append(step)
                    }
                    return false
                }

                return true
            }

            // remove any paths to search with distances more than our current shortest solution
            let currentShortestSolution = solutions.sorted(by: stepSortingBlock).first?.stepCount ?? Int.max
            toSearch = toSearch.filter { $0.stepCount < currentShortestSolution }//.sorted(by: stepSortingBlock)
            iteration += 1
            print("Search Space [\(iteration)]: \(toSearch.count)")
        }

        print("All Solutions:\n\(solutions)")
        return solutions.sorted(by: stepSortingBlock).first
    }

    private func bfSearch(step: SearchStep, progress: inout SearchProgress) -> [SearchStep] {
        var step = step // make a mutable copy
//        print("")

        // check to see if this location is a door or key
        if let grid = map[step.location] {
            switch grid {
            case .door(name: let door):
                // we can only proceed if we can unlock the door
                if !step.canUnlock(door: door) {
                    return []
                }
            case .key(name: let key):
                // pick up the key (if we haven't already)
                step = step.pickup(key: key)
            default:
                break
            }
        }

        if let prevSteps = progress.distanceMap[step.location] {
//            print("Step: \(step)\nPrevious: \(prevSteps)")
            // Have we been here before with fewer steps and the same keys?
            if let similarStep = prevSteps[step.hashKey], similarStep.stepCount < step.stepCount {
//                print("\t** Been here before with fewer steps...")
                return []
            }
        }

        // record our distance
        if step.stepCount > 0 {
            if progress.distanceMap[step.location] == nil {
                progress.distanceMap[step.location] = [String: SearchStep]()
            }

            if var locationSteps = progress.distanceMap[step.location] {
                locationSteps[step.hashKey] = step
                progress.distanceMap[step.location] = locationSteps
            } else {
                print("**** Why don't we have a location hash for \(step.location)?")
            }
        }

        // have we hit our goal?
        if step.foundKeys == keys {
//            print("Found all keys!")
            return [step]
        }

        // determine potential next steps
        let nextSteps = MoveDirection.allCases.compactMap { dir -> SearchStep? in
            let nextLocation = step.location.location(for: dir)

            guard let grid = map[nextLocation] else { return nil }

            if case .wall = grid {
                return nil
            } else if case .door(name: let door) = grid, !step.canUnlock(door: door) {
                // avoid locked doors.
                return nil
            } else {
                return step.move(to: nextLocation)
            }
        }
//        print("Next steps: \(nextSteps.count) from \(step.location)")

        return nextSteps
    }
}
