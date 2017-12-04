//
//  DayThree.swift
//  AdventOfCode2017
//
//  Created by Shawn Veader on 12/3/17.
//  Copyright © 2017 v8logic. All rights reserved.
//

import Foundation

struct DayThree: AdventDay {

    struct MemoryRing: CustomDebugStringConvertible {
        let memoryRingIndex: Int
        let startingValue: Int
        let sideLength: Int

        var debugDescription: String {
            return """
                MemoryRing<
                  index: \(memoryRingIndex),
                  start: \(startingValue),
                  end:   \(endingValue),
                  side:  \(sideLength)
                >
                """
        }

        /// Number of memory blocks around the ring
        var blockCount: Int {
            // length of each side (minus corner blocks) * 4,
            //   then add back our corners
            return ((sideLength - 2) * 4) + 4
        }

        var endingValue: Int {
            let value = (startingValue + blockCount) - 1
            guard value >= startingValue else { return startingValue }
            return value
        }

        /// Get the starting, center memory "ring"
        static func centerRing() -> MemoryRing {
            return MemoryRing(index: 0, starting: 1, side:1)
        }

        /// Construct new memory ring with initial values
        init(index: Int, starting: Int, side: Int) {
            memoryRingIndex = index
            startingValue = starting
            sideLength = side
        }

        /// Take in the previous memory ring (index - 1) and calculate the next ring
        init(ring: MemoryRing) {
            memoryRingIndex = ring.memoryRingIndex + 1
            startingValue = ring.endingValue + 1
            sideLength = ring.sideLength + 2
        }

        /// Is the value contained within this memory ring?
        func contains(_ value: Int) -> Bool {
            return (startingValue...endingValue).contains(value)
        }

        /// Calculate the Manhattan Distance to the center ring.
        func distance(_ value: Int) -> Int {
            guard sideLength > 1 else { return 0 } // safeguard for center

            // find offset on a side
            let offset = (value - startingValue) % (sideLength - 1)
            // center index on a side
            let centerIndex = (sideLength / 2) - 1

            // calculate the distance to the center of a side
            let distanceToCenter = Swift.max(offset, centerIndex) - Swift.min(offset, centerIndex)
            // total distance is the ring index (steps to get to center)
            //     and distance to center of the side
            return memoryRingIndex + distanceToCenter
        }
    }

    // MARK: -

    func defaultInput() -> String? {
        return "368078"
    }

    func run(_ input: String? = nil) {
        guard let inputString = input ?? defaultInput(),
              let runInput = Int(inputString)
              else {
                  print("Day 3: 💥 NO INPUT")
                  exit(10)
              }

        let thing = partOne(input: runInput)
        guard let answer = thing else {
            print("Day 3: (Part 1) 💥 Unable to calculate answer.")
            exit(1)
        }
        print("Day 3: (Part 1) Answer ", answer)

        // ...
    }

    // MARK: -

    func partOne(input: Int) -> Int? {
        var ring = MemoryRing.centerRing()
        while (!ring.contains(input)) {
            ring = MemoryRing(ring: ring)
        }

        return ring.distance(input)
    }

    func partTwo(input: String) -> Int? {
        return nil
    }
}

extension DayThree: Testable {
    func runTests() {
        guard testValue(0, equals: partOne(input: 1)),
              testValue(1, equals: partOne(input: 2)),
              testValue(2, equals: partOne(input: 3)),
              testValue(2, equals: partOne(input: 23)),
              testValue(6, equals: partOne(input: 75)),
              testValue(8, equals: partOne(input: 81)),
              true
            else {
                print("Part 1 Tests Failed!")
                return
        }

        print("Done with tests... all pass")
    }
}
