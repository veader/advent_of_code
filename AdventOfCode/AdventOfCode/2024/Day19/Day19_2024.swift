//
//  Day19_2024.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/19/24.
//

import Foundation

struct Day19_2024: AdventDay {
    var year = 2024
    var dayNumber = 19
    var dayTitle = "Linen Layout"
    var stars = 0

    func parse(_ input: String?) -> OnsenDesigns {
        var patterns = [String]()
        var designs = [String]()

        for line in (input ?? "").lines() {
            if line.contains(","), patterns.isEmpty {
                patterns = line.split(separator: ",").map { String($0.trimmingCharacters(in: .whitespacesAndNewlines)) }
            } else { // if !line.isEmpty {
                designs.append(line)
            }
        }

        return OnsenDesigns(patterns: patterns, designs: designs)
    }

    func partOne(input: String?) async-> Any {
        let onsen = parse(input)
        print("Patterns: \(onsen.patterns.count) | Designs: \(onsen.designs.count)")

        var possibleDesigns = 0
        for design in onsen.designs {
            print("[\(Date.now)] Solving for \(design)...")
            if onsen.hasSolution(design: design) {
                possibleDesigns += 1
                print("[\(Date.now)] \tpossible!")
            } else {
                print("[\(Date.now)] \tNOT possible.")
            }
        }
        return possibleDesigns
    }

    func partTwo(input: String?) async -> Any {
        return 0
    }
}
