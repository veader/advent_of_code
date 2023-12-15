//
//  Day13_2023.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/13/23.
//

import Foundation

struct Day13_2023: AdventDay {
    var year = 2023
    var dayNumber = 13
    var dayTitle = "Point of Incidence"
    var stars = 2

    func parse(_ input: String?) -> [MirrorPattern] {
        (input ?? "").split(separator: "\n\n").map(String.init).map(MirrorPattern.init)
    }

    func partOne(input: String?) -> Any {
        let patterns = parse(input)
        let patternNotes = patterns.map { pattern in
            guard let reflection = pattern.reflection() else { print("No reflection!"); return 0 }
            
            switch reflection {
            case .vertical(x: let x):
                return x
            case .horizontal(y: let y):
                return y * 100
            }
        }

        return patternNotes.reduce(0, +)
    }

    func partTwo(input: String?) -> Any {
        let patterns = parse(input)
        let patternNotes = patterns.map { pattern in
            guard let reflection = pattern.reflection(fix: true) else { print("No reflection!"); return 0 }

            switch reflection {
            case .vertical(x: let x):
                return x
            case .horizontal(y: let y):
                return y * 100
            }
        }

        return patternNotes.reduce(0, +)
    }
}
