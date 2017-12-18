//
//  DayFourteen.swift
//  AdventOfCode2017
//
//  Created by Shawn Veader on 12/15/17.
//  Copyright © 2017 v8logic. All rights reserved.
//

import Foundation

struct DayFourteen: AdventDay {

    struct Disk {
        struct BlockCoordinate {
            let x: Int
            let y: Int

            init(_ x: Int, _ y: Int) {
                self.x = x
                self.y = y
            }
        }

        let key: String
        let blocks: [[Int]] // two dimensional array
        var regions: [[Int]] = [[Int]]()
        let size: Int

        init(_ input: String, size: Int = 128) {
            key = input
            self.size = size

            blocks = (0..<size).map { row -> [Int] in
                let knotInput = "\(input)-\(row)"

                if var knotHash  = KnotHash(knotInput, length: 256, useASCII: true) {
                    let hash = knotHash.run()
                    if let binary = hash.hexAsBinary() {
                        return binary.map { $0 == "0" ? 0 : 1 }
                    }
                }

                print("Unable to create knot hash for \(knotInput)")
                return Array(repeatElement(0, count: size))
            }

            // create a blank regions map to fill in later
            regions = (0..<size).map { _ in Array(repeatElement(0, count: size)) }
        }

        /// Go through disk space and find contiguous regions. Returns number of regions found.
        mutating func findRegions() -> Int {
            var regionLabel: Int = 1

            // look through all blocks
            for x in (0..<size) {
                for y in (0..<size) {
                    let coord = BlockCoordinate(x,y)
                    let (usedStatus, regionStatus) = self[coord]
                    // if the block is used and isn't marked as a region, follow it
                    if usedStatus == 1 && regionStatus == 0 {
                        // start the region with this block
                        set(region: regionLabel, coordinate: coord)
                        findContinguousBlocks(label: regionLabel, origin: coord)
                        regionLabel += 1
                    }
                }
            }

            return regionLabel - 1
        }

        private mutating func findContinguousBlocks(label: Int, origin: BlockCoordinate) {
            // check the (up to) four surrounding, continguous blocks to see if they
            //      are used and not part of the region already
            for coord in contiguousCoordinates(to: origin) {
                let (usedStatus, regionStatus) = self[coord]
                if usedStatus == 1 {
                    if regionStatus == 0 {
                        set(region: label, coordinate: coord)
                        // recurse
                        findContinguousBlocks(label: label, origin: coord)
                    } else if regionStatus != label {
                        // how do we have a contiguous block that has a different label
                        print("Found a previously marked region!")
                        print("\(origin) -> \(coord) | \(label) -> \(regionStatus)")
                    }
                }
            }
        }

        private func contiguousCoordinates(to: BlockCoordinate) -> [BlockCoordinate] {
            var nearby = [BlockCoordinate]()

            if to.x - 1 >= 0 { // left
                nearby.append(BlockCoordinate(to.x - 1, to.y))
            }

            if to.x + 1 < size { // right
                nearby.append(BlockCoordinate(to.x + 1, to.y))
            }

            if to.y - 1 >= 0 { // up
                nearby.append(BlockCoordinate(to.x, to.y - 1))
            }

            if to.y + 1 < size { // down
                nearby.append(BlockCoordinate(to.x, to.y + 1))
            }

            return nearby
        }

        private mutating func set(region: Int, coordinate: BlockCoordinate) {
            regions[coordinate.x][coordinate.y] = region
        }

        /// Returns the value in the blocks and regions grids for a given coordinate
        subscript(coordinate: BlockCoordinate) -> (Int, Int) {
            return (blocks[coordinate.x][coordinate.y],
                    regions[coordinate.x][coordinate.y])
        }

        func freeSpace() -> Int {
            let allBlocks = size * size
            return allBlocks - usedSpace()
        }

        func usedSpace() -> Int {
            return blocks.map { row -> Int in
                return row.reduce(0, +)
            }.reduce(0, +)
        }

        func printState(withRegions: Bool = false) {
            for row in blocks {
                let rowString = row.map { $0 == 0 ? "." : "#" }.joined()
                print(rowString)
            }

            if withRegions {
                print("--------------------------------------------------------")
                for row in regions {
                    let rowString = row.map { (block: Int) -> String in
                        if block == 0 {
                            return "."
                        } else {
                            let blockString = "\(block)"
                            return String(blockString.suffix(1))
                        }
                    }.joined()
                    print(rowString)
                }
            }
        }
    }


    // MARK: -

    func defaultInput() -> String? {
        return "ffayrhll"
    }

    func run(_ input: String? = nil) {
        guard let runInput = input ?? defaultInput() else {
            print("Day 14: 💥 NO INPUT")
            exit(10)
        }

        let thing = partOne(input: runInput)
        guard let answer = thing else {
            print("Day 14: (Part 1) 💥 Unable to calculate answer.")
            exit(1)
        }
        print("Day 14: (Part 1) Answer ", answer)

        let thing2 = partTwo(input: runInput)
        guard let answer2 = thing2 else {
            print("Day 14: (Part 2) 💥 Unable to calculate answer.")
            exit(1)
        }
        print("Day 14: (Part 2) Answer ", answer2)
    }

    // MARK: -

    func partOne(input: String) -> Int? {
        let disk = Disk(input)
        return disk.usedSpace()
    }

    func partTwo(input: String) -> Int? {
        var disk = Disk(input)
        return disk.findRegions()
    }
}
