//
//  Day11_2025.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/12/25.
//

import Foundation

struct Day11_2025: AdventDay {
    var year = 2025
    var dayNumber = 11
    var dayTitle = "Reactor"
    var stars = 1

    typealias ReactorGraph = [String: [String]]

    func parse(_ input: String?) -> ReactorGraph {
        var graph = ReactorGraph()
        for line in (input ?? "").lines() {
            let addrs = line.split(separator: /\s+/).map(String.init)
            guard var inputAddr = addrs.first, inputAddr.hasSuffix(":") else { continue }
            inputAddr.removeLast(1)
            graph[inputAddr] = Array(addrs[1..<addrs.count])
        }

        return graph
    }

    func partOne(input: String?) -> Any {
        let graph = parse(input)
        var paths = Set<[String]>()
        searchForAllPaths(graph: graph, node: "you", path: [], allPaths: &paths)
        return paths.count
    }

    func partTwo(input: String?) -> Any {
        let graph = parse(input)
        var paths = Set<[String]>()
        searchForAllPaths(graph: graph, node: "svr", path: [], allPaths: &paths, part2: true)
        return paths.count
    }

    /// depth-first search?
    func searchForAllPaths(graph: ReactorGraph, node: String, path: [String], allPaths: inout Set<[String]>, part2: Bool = false) {
        // goal is "out"
        guard node != "out" else {
            // we've reached the end

            // for part 2 this path is only valid if it passes through fft and dac
            if part2 {
                guard valid(path: path) else { return }
            }

            allPaths.insert(path + [node])
            return
        }

        // where can we go from here? (excluding where we just came from)
        guard let options = graph[node]?.filter({ $0 != path.last }) else { return }
        for option in options {
            searchForAllPaths(graph: graph, node: option, path: path + [node], allPaths: &allPaths, part2: part2)
        }
    }

    /// For part 2, we need to know if the path passes through `fft` and `dac`
    func valid(path: [String]) -> Bool {
        path.contains("fft") && path.contains("dac")
    }
}
