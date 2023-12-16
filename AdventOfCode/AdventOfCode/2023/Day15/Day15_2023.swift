//
//  Day15_2023.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/15/23.
//

import Foundation

struct Day15_2023: AdventDay {
    var year = 2023
    var dayNumber = 15
    var dayTitle = "Lens Library"
    var stars = 1

    func parse(_ input: String?) -> [String] {
        ((input ?? "").lines().first ?? "").split(separator: ",").map(String.init)
    }

    func partOne(input: String?) -> Any {
        let parts = parse(input)
        return parts.map(\.simpleHash).reduce(0, +)
    }

    func partTwo(input: String?) -> Any {
        return 0
    }
}

extension String {
    public var simpleHash: Int {
        var value = 0
        
        for char in self {
            guard let ascii = char.asciiValue else {
                print("⚠️ Unknown value for \(char)") // TODO: should we throw?
                continue
            }

            value = ((value + Int(ascii)) * 17) % 256
        }

        return value
    }
}
