//
//  SandSim.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/16/22.
//

import Foundation
import RegexBuilder

class SandSim {
    // parse lines into coordinate pieces (each pair makes a line)
    // make map from lines
    //   - take lines and create list of coordinates that are rock
    // printing
    // simulate sand falling

    let paths: [[Coordinate]]
    let lines: [[Coordinate]]

    var rocks: [Coordinate]

    init(paths: [[Coordinate]]) {
        self.paths = paths
        self.lines = [] // TODO
        self.rocks = []

        findRocks()
    }

    func findRocks() {

    }

    func pointsInLine(start: Coordinate, end: Coordinate) -> [Coordinate] {
        // lines (for now) are only straight horizontal or vertical
        guard start.x == end.x || start.y == end.y else { return [] }

        if start.x == end.x { // vertical line
            
        }
        return []
    }


    static func parse(_ input: String) -> [[Coordinate]] {
        input.split(separator: "\n").map(String.init).map { line in
            line.matches(of: rockRegex).compactMap { match in
                guard let x = Int(match.1), let y = Int(match.2) else { print("😬"); return nil }
                return Coordinate(x: x, y: y)
            }
        }
    }

    static let rockRegex = Regex {
        Capture {
            OneOrMore(.digit)
        }
        ","
        Capture {
            OneOrMore(.digit)
        }
        Optionally {
            OneOrMore(.whitespace)
            "->"
            OneOrMore(.whitespace)
        }
    }
}
