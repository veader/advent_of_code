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

    init(paths: [CavePath]) {
        self.paths = paths
        self.endPoints = Set(paths.flatMap({ [$0.start, $0.end] }).unique())

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
    func isSmall(cave: String) -> Bool {
        cave.lowercased() == cave
    }

    func findAllPaths(from endPoint: String = "start", currentPath: [String] = [], visited: Set<String> = [], debugPrint: Bool = false) -> [[String]] {
        if debugPrint {
            print("\(#function): point: \(endPoint), path: \(currentPath), visited: \(visited)")
        }

        guard endPoint != "end" else {
            // we've hit the end, return successful path
            if debugPrint {
                print("\tSUCCESS: \(currentPath + [endPoint])")
            }
            return [currentPath + [endPoint]]
        }

        // find all possible choices from this point
        let choices = paths(from: endPoint).filter { point in
            // filter choices based on if they have been visited and *can* be visited again
            if visited.contains(point) && isSmall(cave: point) {
                // avoid previously visited small caves
                return false
            } else {
                // either BIG cave or unvisited
                return true
            }
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

        let newCurrentPath = currentPath + [endPoint]
        let newVisited = visited.union([endPoint])
        return choices.flatMap { point in
            findAllPaths(from: point, currentPath: newCurrentPath, visited: newVisited, debugPrint: debugPrint)
        }
    }
}
