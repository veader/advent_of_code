//
//  EmptyDay.swift
//  aoc2019
//
//  Created by Shawn Veader on 12/1/19.
//  Copyright © 2019 Shawn Veader. All rights reserved.
//

import Foundation

/// Sample empty day to use to start a new day in the Advent of Code
struct EmptyDay: AdventDay {
    var dayNumber: Int = 0

    @discardableResult func run(_ input: String? = nil, _ part: Int? = 1) -> Any {
        return 0
        /*
        guard let input = input ?? defaultInput else {
            print("Day \(dayNumber): NO INPUT")
            exit(10)
        }

        if part == 1 {
            let answer = partOne(tree: tree)
            print("Day \(dayNumber) Part \(part!): Final Answer \(answer)")
            return answer
        } else {
            let answer = partTwo(tree: tree)
            print("Day \(dayNumber) Part \(part!): Final Answer \(answer)")
            return answer
        }
         */
    }

    /*
    func partOne(tree: LicenseTree) -> Int {
        guard let rootNode = tree.rootNode else { return Int.min }
        return metadataSum(for: rootNode)
    }

    func partTwo(tree: LicenseTree) -> Int {
        guard let rootNode = tree.rootNode else { return Int.min }
        return sumNodeValue(for: rootNode)
    }
     */
}
