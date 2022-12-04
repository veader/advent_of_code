//
//  DayFour2022.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/4/22.
//

import Foundation
import RegexBuilder

struct DayFour2022: AdventDay {
    var year = 2022
    var dayNumber = 4
    var dayTitle = "Camp Cleanup"
    var stars = 1

    static let sideRegex = Regex {
        Capture {
            OneOrMore(.digit)
        }

        One("-")

        Capture {
            OneOrMore(.digit)
        }
    }

    static let parsingRegex = Regex {
        sideRegex

        OneOrMore(",")

        sideRegex
    }

    struct CampSections {
        let elf1: ClosedRange<Int>
        let elf2: ClosedRange<Int>

        init?(_ input: String) {
            guard
                let match = input.firstMatch(of: DayFour2022.parsingRegex),
                let side1Start = Int(match.1),
                let side1End = Int(match.2),
                let side2Start = Int(match.3),
                let side2End = Int(match.4)
            else { return nil }

            elf1 = side1Start...side1End
            elf2 = side2Start...side2End
        }

        func fullyOverlaps() -> Bool {
            let ranges = [elf1, elf2].sorted(by: { $0.count > $1.count })
            return ranges[0].contains(ranges[1])
        }
    }

    func parse(_ input: String?) -> [CampSections] {
        (input ?? "").split(separator: "\n").map(String.init).compactMap { CampSections($0) }
    }

    func partOne(input: String?) -> Any {
        let sections = parse(input)
        return sections.filter { $0.fullyOverlaps() }.count
    }

    func partTwo(input: String?) -> Any {
        return 0
    }
}
