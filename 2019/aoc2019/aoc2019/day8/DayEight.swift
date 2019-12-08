//
//  DayEight.swift
//  aoc2019
//
//  Created by Shawn Veader on 12/8/19.
//  Copyright © 2019 Shawn Veader. All rights reserved.
//

import Foundation

struct DayEight: AdventDay {
    var dayNumber: Int = 8

    func parse(_ input: String?) -> [Int] {
        (input ?? "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .compactMap(String.init)
            .compactMap(Int.init)
    }

    func partOne(input: String?) -> Any {
        let width = 25
        let height = 6

        let image = SpaceImage(width: width, height: height, data: parse(input))
        if let zeroLayer = image.layer(fewest: 0) {
            return zeroLayer.count(pixel: 1) * zeroLayer.count(pixel: 2)
        }

        return 0
    }

    func partTwo(input: String?) -> Any {
        let width = 25
        let height = 6

        let image = SpaceImage(width: width, height: height, data: parse(input))
        print(image)
        return 0
    }
}
