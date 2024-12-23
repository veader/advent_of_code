//
//  OnsenDesigns.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/20/24.
//

import Foundation

class OnsenDesigns {
    let patterns: [String]
    let designs: [String]


    // MARK: - Init

    init(patterns: [String], designs: [String]) {
        self.patterns = patterns
        self.designs = designs
    }


    // MARK: - First Attempt

    /// What is the longest individual pattern to use in our pattern matching...
    var longestPattern: Int {
        patterns.sorted(by: { $0.count < $1.count }).last?.count ?? 0
    }

    /// Create the given design with available patterns.
    func solve(design: String) -> [String]? {
        var solution: [String] = []
        var ptr = design.startIndex
        let longest = longestPattern

        while ptr < design.endIndex {
            var len = longest
            var foundPattern = false
            let theRest = design[ptr...]
            if theRest.count < len { len = theRest.count }

            while len > 0 {
                let chunk = String(theRest.prefix(len))
                if patterns.contains(chunk) {
                    solution.append(chunk)
                    ptr = design.index(ptr, offsetBy: chunk.count)
                    foundPattern = true
                    break
                } else {
                    len -= 1
                }
            }

            guard foundPattern else {
                print("Found no solution for \(design) | Start: \(solution.joined(separator: ","))");
                break
            }
        }

        guard solution.joined() == design else { return nil }
        return solution
    }

    
    // MARK: - Second Attempt

    /// Attempt to find all possible solutions for the given design.
    ///
    /// Does a breadth-first search based on prefix of the string, attempting to
    /// async solve as it goes.
    func solutionSearch(design: String) async -> [[String]] {
        await recursiveSolve(design: design, parts: [])
    }

    /// Attempt to find all possible solutions for the design (fragment).
    private func recursiveSolve(design fragment: String, parts: [String]) async -> [[String]] {
        // if we've reached the end, return our "path" here.
        guard !fragment.isEmpty else { return [parts] }

        // determine if we have any possible paths forward from this point
        let prefixes = possiblePrefixes(for: fragment)
        guard !prefixes.isEmpty else { return [] }

        // iterate "down" for each possible prefix to look for solutions
        var possiblePaths: [[String]] = []
        for prefix in prefixes {
            let rest = String(fragment.trimmingPrefix(prefix))
            let solutions = await recursiveSolve(design: rest, parts: parts + [prefix])
            if !solutions.isEmpty {
                possiblePaths.append(contentsOf: solutions)
            }
        }

        return possiblePaths
    }

    /// Attempt to find all possible prefixes for the design (fragment)
    private func possiblePrefixes(for designFragment: String) -> [String] {
        patterns.filter { designFragment.hasPrefix($0) }.sorted(by: { $0.count > $1.count })
    }


    // MARK: - Third Attempt

    func hasSolution(design: String) -> Bool {
        recursiveSolutionCheck(design: design)
    }

    /// Attempt to find if there are *any* available solutions for the given design (fragment)
    private func recursiveSolutionCheck(design fragment: String) -> Bool {
        // if we've reached the end, return our "path" here.
        guard !fragment.isEmpty else { return true }

        // determine if we have any possible paths forward from this point
        let prefixes = possiblePrefixes(for: fragment)
        guard !prefixes.isEmpty else { return false }

        // iterate "down" for each possible prefix to look for solutions
        for prefix in prefixes {
            if recursiveSolutionCheck(design: String(fragment.trimmingPrefix(prefix))) {
                return true // found a solution "below" us
            }
        }

        return false // nothing here
    }


    // MARK: - Printing

    var arrangedPatterns: [Int: [String]] {
        var output = [Int: [String]]()
        for pattern in patterns {
            output[pattern.count] = (output[pattern.count] ?? []) + [pattern]
        }
        return output
    }

    func printPatterns() {
        let pats = arrangedPatterns
        for size in pats.keys.sorted() {
            guard let sizedPatterns = pats[size] else { continue }
            print(sizedPatterns.sorted().joined(separator: "\n"))
        }
    }
}
