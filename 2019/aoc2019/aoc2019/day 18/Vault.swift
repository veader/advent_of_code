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
        keys = tmpKeys
        doors = tmpDoors
    }

    // MARK: - Path Finding
    struct SearchProgress {
        var visited = [Coordinate]()
        var foundKeys = [String]()
        var doorsUnlocked = [String]()
        var stepCount = 0
        var finished = false

        mutating func pickup(key: String) {
            guard !foundKeys.contains(key) else { return }
            foundKeys.append(key)
        }

        mutating func unlock(door: String) {
            guard !doorsUnlocked.contains(door) else { return }
            doorsUnlocked.append(door)
        }

        var hashKey: String {
            "L:\(visited.last) K:\(foundKeys) D:\(doorsUnlocked)"
        }
    }

    func searchForAllKeys() -> SearchProgress? {
        guard let start = startLocation else { return nil }

        var possibilities = [SearchProgress]()
        var solutions = [SearchProgress]()
        var searchHash = [String: Bool]()

        // kick search off at the start
        var progress = SearchProgress()
        progress.visited.append(start)
        possibilities.append(progress)
        searchHash[progress.hashKey] = true

        var iterations = 0
        while !possibilities.isEmpty {
            // TODO: rewrite this with a normal for loop to try and save some of the efforts

            // for each possible location, find all new possibilities
            possibilities = possibilities.flatMap { search(progress: $0, hash: searchHash) }
                                         .sorted { $0.stepCount < $1.stepCount }

            // add hashes for possibilities
            possibilities.forEach { searchHash[$0.hashKey] = true }

            // filter out (and save) any real solutions
            possibilities = possibilities.filter { progress -> Bool in
                if progress.finished {
                    print("FOUND A SOLUTION!!!! ----------------------------")
                    solutions.append(progress)
                    return false
                }
                return true
            }

            // filter out any possibilities with steps more than one of our solutions
            if let shortestPath = solutions.sorted(by: { $0.stepCount < $1.stepCount }).first {
                let countBefore = possibilities.count
                possibilities = possibilities.filter { $0.stepCount > shortestPath.stepCount }
                let countAfter = possibilities.count
                print("Given our \(solutions.count) solutions: we limited \(countBefore) down to \(countAfter)")
            }

            let beforeCount = possibilities.count
            // filter out any duplicates in the possibilities
            possibilities = possibilities
                    .sorted(by: { $0.stepCount < $1.stepCount }) // sort by step counts
                    .reduce([]) { result, progress -> [SearchProgress] in
                        if result.first(where: { $0.hashKey == progress.hashKey }) != nil {
                            return result // already exists in this collection, with shorter step count
                        } else {
                            return result + [progress]
                        }
                    }
            print("Removed \(beforeCount - possibilities.count) duplicates...")

            print("\(possibilities.count) possibilities at iteration \(iterations)")
            // printPossibilities(possibilities)
            print("\(searchHash.keys.count) hash keys")

            iterations += 1
            if iterations > 10_000 {
                break
            }
        }

//        print("Solutions: (\(solutions.count))\n\(solutions)")

        return solutions.sorted { $0.stepCount < $1.stepCount }.first ?? SearchProgress()
    }

    /// BFS from the given location to find the shortest path to reach all keys
    private func search(progress: SearchProgress, hash: [String: Bool]) -> [SearchProgress] {
        // make it so we can mutate this progress
        var progress = progress

        // where are we?
        guard let location = progress.visited.last else { return [] }
        // print("Examining: \(location)")

        // what do we need to do at this location?
        if let gridType = map[location] {
            if case .door(name: let door) = gridType {
                if progress.foundKeys.contains(door.lowercased()) {
                    // unlock door, if we haven't already
                    // print("Unlocked '\(door)'")
                    progress.unlock(door: door)
                } else {
                    print("Somehow we moved to a door without the key for it")
                    return [] // we shouldn't be here
                }
            } else if case .key(name: let key) = gridType {
                // pick up the key if we haven't already
                // print("Picked up key '\(key)'")
                progress.pickup(key: key)
            }
        }

        // end goal -> find all keys
        // TODO: idea, pass closure in to measure "finished"? (SearchProgress) -> Bool
        if progress.foundKeys.sorted() == keys.sorted() {
            print("Found all the keys!")
            progress.finished = true
            return [progress]
        }

        // determine available steps from here
        let searchable = MoveDirection.allCases
            .map { location.location(for: $0) } // get neighboring locations
            .filter { coord -> Bool in
                guard let grid = map[coord] else { print("?"); return false }

                // determine if we *can* travel to the neighboring map location
                switch grid {
                case .wall:
                    // print("\(coord) is a wall")
                    return false // can't pass through walls
                case .door(name: let door):
                    // print("\(coord) is a door: \(door)")
                    if progress.doorsUnlocked.contains(door) {
                        // we have already unlocked this door, so we can pass through again
                        return true
                    } else if progress.foundKeys.contains(door.lowercased()) {
                        // we have a key to unlock the door
                        return true
                    } else {
//                        print("Hit door we don't have a key for: \(door)")
                        return false
                    }
                case .key(name: _):
                    // print("\(coord) is a key: \(key)")
                    return true
                default: // empty and start
                    return true
                }
            }

        // avoid twittering between adjacent locations
//        if let prev = prevLocation, searchable.count > 1, canGoBackwards == false {
//            searchable = searchable.filter { prev != $0 }
//        }

//        print("Searchable: \(searchable)")

        return searchable.compactMap { coordinate -> SearchProgress? in
            // for each possible searchable location, create an updated progress
            var newProgress = progress // copy
            newProgress.visited.append(coordinate)
            newProgress.stepCount += 1

            guard !hash.keys.contains(newProgress.hashKey) else {
//                print("\tNot taking this route since we've been here before. \(newProgress.hashKey)")
                return nil
            }
            return newProgress
        }
    }

    private func printPossibilities(_ possibilities: [SearchProgress]) {
        print("Possibilities:")
        possibilities.forEach { print($0) }
        print("Count: \(possibilities.count)\n")
    }
}
