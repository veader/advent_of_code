//
//  DayThree2022.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/3/22.
//

import Foundation

struct DayThree2022: AdventDay {
    var year = 2022
    var dayNumber = 3
    var dayTitle = "Rucksack Reorganization"
    var stars = 1

    struct Rucksack {
        let compartment1: [String]
        let compartment2: [String]

        init?(_ input: String) {
            guard input.count % 2 == 0 else { return nil }

            let frontHalf = input.prefix(input.count/2)
            let backHalf = input.suffix(input.count/2)

            compartment1 = frontHalf.map(String.init)
            compartment2 = backHalf.map(String.init)
        }

        func misplacedItem() -> String? {
            let common = Set(compartment1).intersection(Set(compartment2))
            return common.first
        }
    }

    func priority(of item: String) -> Int {
        guard let char = item.first else { return -1 }

        let lowerLetters = "abcdefghijklmnopqrstuvwxyz"
        let upperLetters = lowerLetters.uppercased()

        if lowerLetters.contains(item) {
            let idx = lowerLetters.firstIndex(of: char)!
            let distance = lowerLetters.distance(from: lowerLetters.startIndex, to: idx)
            return 1 + distance
        } else if upperLetters.contains(item) {
            let idx = upperLetters.firstIndex(of: char)!
            let distance = upperLetters.distance(from: upperLetters.startIndex, to: idx)
            return 27 + distance
        } else {
            return 0
        }
    }

    func parse(_ input: String?) -> [Rucksack] {
        (input ?? "").split(separator: "\n").map(String.init).compactMap { Rucksack($0) }
    }

    func partOne(input: String?) -> Any {
        let rucksacks = parse(input)
        return rucksacks
            .compactMap { $0.misplacedItem() }
            .map { priority(of: $0) }
            .reduce(0, +)
    }

    func partTwo(input: String?) -> Any {
        return 0
    }
}
