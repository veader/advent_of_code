//
//  CaveMap.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/13/21.
//

import Foundation

struct CavePath {
    let start: String
    let end: String

    init?(_ input: String) {
        let pieces = input.split(separator: "-").map(String.init)
        guard
            pieces.count == 2,
            let first = pieces.first,
            let last = pieces.last
        else { return nil }

        self.start = first
        self.end = last
    }

    func contains(_ endPoint: String) -> Bool {
        start == endPoint || end == endPoint
    }
}

class CaveMap {
    let paths: [CavePath]
    let endPoints: Set<String>
    let smallCaves: Set<String>

    init(paths: [CavePath]) {
        self.paths = paths
        self.endPoints = Set(paths.flatMap({ [$0.start, $0.end] }).unique())
        self.smallCaves = endPoints.filter { CaveMap.isSmall(cave: $0) }

        // TODO: Do we need to confirm a `start` and `end`?
    }

    /// Find all available paths from a given endpoint
    func paths(from endPoint: String) -> Set<String> {
        Set(paths.compactMap({ p in
            guard p.contains(endPoint) else { return nil }
            if p.start == endPoint {
                return p.end
            } else {
                return p.start
            }
        }))
    }

    /// Is the given "cave" a small cave?
    static func isSmall(cave: String) -> Bool {
        cave.lowercased() == cave
    }

    /// Find all paths from the given end-point (defaults to `start`) to `end`.
    ///
    /// If `allowDoubleSmall` is `false`: a small cave can only be visited once.
    ///
    /// If `allowDoubleSmall` is `true`: a *single* small cave may be visited at most twice.
    ///
    /// - parameters:
    ///     - endPoint: `String` - name of endpoint to start from. (Defaults to `start`)
    ///     - currentPath: `[String]` - collection of points on the path we have visited to this point. (Defaults to empty collection)
    ///     - allowDoubleSmall: `Bool` - should small caves allow a second visit? (_See note_, Defaults to false)
    ///     - debugPrint: `Bool` - should debug prints be performed (useful for debugging - Defaults to false)
    ///
    /// - returns: [[String]] - A series of possible paths from `endPoint` to `end`.
    func findAllPaths(from endPoint: String = "start", currentPath: [String] = [], allowDoubleSmall: Bool = false, debugPrint: Bool = false) -> [[String]] {
        if debugPrint {
            print("\(#function): point: \(endPoint), path: \(currentPath), allowDoubleSmall: \(allowDoubleSmall ? "true" : "false")")
        }

        let newCurrentPath = currentPath + [endPoint]

        guard endPoint != "end" else {
            // we've hit the end, return successful path
            if debugPrint {
                print("\tSUCCESS: \(newCurrentPath)")
            }
            return [newCurrentPath]
        }

        // find all possible choices from this point
        let choices = paths(from: endPoint).filter { point in
            guard point != "start" else { return false }

            // filter choices based on if they have been visited and *can* be visited again

            // when considering small caves, follow the proper rules
            if smallCaves.contains(point) {
                if newCurrentPath.contains(point) {
                    if debugPrint {
                        print("\t\tSmall cave: \(point) is already in current path")
                    }

                    if allowDoubleSmall && containsDoubleSmallVisit(path: newCurrentPath) {
                        // a small cave in the path has already been visited twice and this cave has been visited already
                        return false
                    } else if !allowDoubleSmall {
                        // this small cave has already been visited once
                        return false
                    }
                } else {
                    if debugPrint {
                        print("\t\tSmall cave: \(point) is NOT already in current path")
                    }
                }
            }

            // either BIG cave or unvisited
            return true
        }

        // if no choices exist, this is an invalid path
        guard choices.count > 0 else {
            if debugPrint {
                print("\tDead end...")
            }
            return []
        }

        if debugPrint {
            print("\tChoices: \(choices)")
        }

        return choices.flatMap { point in
            findAllPaths(from: point, currentPath: newCurrentPath, allowDoubleSmall: allowDoubleSmall, debugPrint: debugPrint)
        }
    }

    /// Does the given path have a small cave that was visited twice?
    func containsDoubleSmallVisit(path: [String]) -> Bool {
        let filteredCaves = path.filter { smallCaves.contains($0) }
        return filteredCaves.count != filteredCaves.unique().count
    }
}
