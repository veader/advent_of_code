//
//  Day9_2024.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/9/24.
//

import Foundation

struct Day9_2024: AdventDay {
    var year = 2024
    var dayNumber = 9
    var dayTitle = "Disk Fragmenter"
    var stars = 2

    func parse(_ input: String?) -> [Int] {
        (input ?? "").charSplit().compactMap(Int.init)
    }

    func partOne(input: String?) -> Any {
        let disk = SimpleDisk(diskMap: parse(input))
        disk.defrag()
        return disk.calculateChecksum()
    }

    func partTwo(input: String?) -> Any {
        let disk = SimpleDisk(diskMap: parse(input))
        disk.wholeFileDefrag()
        return disk.calculateChecksum(basic: false)
    }
}
