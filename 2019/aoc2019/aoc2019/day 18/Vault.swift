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

    struct SearchProgress {
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

        while !toSearch.isEmpty {
            toSearch = toSearch.flatMap { bfSearch(step: $0, progress: &progress) }

            // remove (and record) any found solutions
            toSearch = toSearch.filter { step -> Bool in
                if step.foundKeys == sortedKeys {
                    print("SOLUTION: \(step)")
                    solutions.append(step)
                    return false
                }

                return true
            }

            // remove any paths to search with distances more than our current shortest solution
            let currentShortestSolution = solutions.sorted(by: stepSortingBlock).first?.stepCount ?? Int.max
            toSearch = toSearch.filter { $0.stepCount < currentShortestSolution }//.sorted(by: stepSortingBlock)
        }

        print("All Solutions:\n\(solutions)")
        return solutions.sorted(by: stepSortingBlock).first
    }

    private func bfSearch(step: SearchStep, progress: inout SearchProgress) -> [SearchStep] {
        var step = step // make a mutable copy
        print("")

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
            print("Step: \(step)\nPrevious: \(prevSteps)")
            // Have we been here before with fewer steps and the same keys?
            if let similarStep = prevSteps[step.hashKey], similarStep.stepCount < step.stepCount {
                print("\t** Been here before with fewer steps...")
                return []
            }

            // TODO: HERE FIX THIS
            // TODO: should store an array of optional steps that have different keys at this location?
//            if prevStep.stepCount < step.stepCount && prevStep.foundKeys.count >= step.foundKeys.count {
//                // previous step has more (or the same amount) keys.
//                //  check that that this step has just a subset...
//                let prevKeySet = Set(prevStep.foundKeys)
//                let thisKeySet = Set(step.foundKeys)
//                if thisKeySet.isSubset(of: prevKeySet) {
//                    print("** No path forward.")
//                    return [] // we visited here before on a shorter route
//                }
//            } else if prevStep == step { // same info
//                print("** Duplicate... move on")
//                return []
//            }
        }

        // record our distance
        if step.stepCount > 0 {
            if let otherSteps = progress.distanceMap[step.location] {
                progress.distanceMap[step.location] = otherSteps + [step]
            } else {
                progress.distanceMap[step.location] = [step]
            }
        }

        // have we hit our goal?
        if step.foundKeys == keys {
            print("Found all keys!")
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
                let nextStep = step.move(to: nextLocation)

                // This shouldn't be needed because the stepCount should change, right?
//                // avoid duplicate steps
//                if let prevStep = progress.distanceMap[nextLocation], prevStep == nextStep {
//                    return nil
//                }

                return nextStep
            }
        }
        print("Next steps: \(nextSteps.count) from \(step.location)")

        return nextSteps
    }
}
