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

    struct MemorySpace: CustomDebugStringConvertible {
        struct MemoryAddress {
            let x: Int
            let y: Int

            func next(_ direction: Direction) -> MemoryAddress {
                switch direction {
                case .up:
                    return up()
                case .down:
                    return down()
                case .left:
                    return left()
                case .right:
                    return right()
                case .done:
                    return self
                }
            }

            func previous(_ direction: Direction) -> MemoryAddress {
                switch direction {
                case .up:
                    return down()
                case .down:
                    return up()
                case .left:
                    return right()
                case .right:
                    return left()
                case .done:
                    return self
                }
            }

            func up() -> MemoryAddress {
                return MemoryAddress(x: x, y: y - 1)
            }

            func down() -> MemoryAddress {
                return MemoryAddress(x: x, y: y + 1)
            }

            func left() -> MemoryAddress {
                return MemoryAddress(x: x - 1, y: y)
            }

            func right() -> MemoryAddress {
                return MemoryAddress(x: x + 1, y: y)
            }
        }

        enum Direction: Int {
            case up = 0
            case left
            case down
            case right
            case done

            func next() -> Direction {
                switch self {
                case .up:
                    return .left
                case .left:
                    return .down
                case .down:
                    return .right
                case .right:
                    return .done
                case .done:
                    return .up
                }
            }
        }

        let sideLength: Int
        var blocks: [[Int]]

        lazy var center: MemoryAddress = {
            let middleIndex = (sideLength - 1) / 2
            return MemoryAddress(x: middleIndex, y: middleIndex)
        }()

        var debugDescription: String {
            var output = ""

            let maxMem = blocks.flatMap { (row: [Int]) -> Int? in
                    row.max()
                }.max()
            let width = String(describing: maxMem!).count + 2

            let dashes = String(repeating: "-", count: width)
            let line = "+" + String(repeating: "\(dashes)+", count: sideLength) + "\n"
            output += line

            for row in blocks {
                var rowOutput = "|"
                for block in row {
                    let blockStr = String(describing: block).padding(toLength: width - 1, withPad: " ", startingAt: 0)
                    rowOutput += " \(blockStr)|"
                }
                output += rowOutput + "\n"
                output += line
            }

            return output
        }

        init(size: Int) {
            sideLength = size
            blocks = Array(repeating: Array(repeating: 0, count: sideLength),
                           count: sideLength)
        }

        func addressIsValid(_ addr: MemoryAddress) -> Bool {
            let validRange = 0..<sideLength
            return validRange.contains(addr.x) && validRange.contains(addr.y)
        }

        subscript(index: MemoryAddress) -> Int {
            get {
                guard addressIsValid(index) else { return 0 }
                return blocks[index.y][index.x]
            }
            set {
                assert(addressIsValid(index), "Invaid address!")
                blocks[index.y][index.x] = newValue
            }
        }

        func surroundingSum(index: MemoryAddress) -> Int {
            guard addressIsValid(index) else { return 0 }
            return  self[index.up()] +
                    self[index.up().left()] +
                    self[index.left()] +
                    self[index.left().down()] +
                    self[index.down()] +
                    self[index.down().right()] +
                    self[index.right()] +
                    self[index.right().up()]
        }

        /// Loop (starting from center) around address space summing
        ///     surrounding blocks until we reach (or exceed) a value
        mutating func loopSumming(until value: Int) -> Int {
            // priming loop
            var addr = center
            self[addr] = 1
            var ringSize = 1 // center has side length of 1

            while addressIsValid(addr) {
                ringSize += 2 // move to next ring
                addr = addr.right() // to start a ring, move right to starting location
                guard addressIsValid(addr) else { break }

                var direction: Direction = .up

                while (direction != .done) {
                    // work on a new side of the current loop
                    var sideIndex = 0
                    while (sideIndex < ringSize - 1) {
                        let sum = surroundingSum(index: addr)
                        self[addr] = sum

                        guard sum < value else { return sum }
                        sideIndex += 1
                        addr = addr.next(direction)
                    }

                    // we always move one too many, back up
                    addr = addr.previous(direction)

                    // change our direction and move one step that way
                    direction = direction.next()
                    addr = addr.next(direction)
                }
            }

            return 0
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

        let thing2 = partTwo(input: runInput)
        guard let answer2 = thing2 else {
            print("Day 3: (Part 2) 💥 Unable to calculate answer.")
            exit(1)
        }
        print("Day 3: (Part 2) Answer ", answer2)
    }

    // MARK: -

    func partOne(input: Int) -> Int? {
        let ring = findRing(input: input)
        // print(ring)

        return ring.distance(input)
    }

    func partTwo(input: Int) -> Int? {
        let ring = findRing(input: input)
        var addressSpace = MemorySpace(size: ring.sideLength)

        // print(addressSpace)
        let sum = addressSpace.loopSumming(until: input)
        // print(addressSpace)

        return sum
    }

    func findRing(input: Int) -> MemoryRing {
        var ring = MemoryRing.centerRing()
        while (!ring.contains(input)) {
            ring = MemoryRing(ring: ring)
        }

        return ring
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

        guard testValue(23, equals: partTwo(input: 20))
            else {
                print("Part 2 Tests Failed!")
                return
        }

        print("Done with tests... all pass")
    }
}
