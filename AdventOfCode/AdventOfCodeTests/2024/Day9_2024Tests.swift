//
//  Day9_2024Tests.swift
//  AdventOfCodeTests
//
//  Created by Shawn Veader on 12/9/24.
//

import Testing
import Foundation

struct Day9_2024Tests {

    let sampleDataEasy = "12345"
    let sampleData = "2333133121414131402"
    let sampleData2 = "233313312141413140232"

    let day = Day9_2024()

    @Test func testSimpleDiskCreation() async throws {
        let disk = SimpleDisk(diskMap: day.parse(sampleDataEasy))
        #expect(disk.printDisk() == "0..111....22222")

        let disk2 = SimpleDisk(diskMap: day.parse(sampleData))
        #expect(disk2.printDisk() == "00...111...2...333.44.5555.6666.777.888899")
    }

    @Test func testDiskDefrag() async throws {
        let disk = SimpleDisk(diskMap: day.parse(sampleData))
        disk.defrag()
        #expect(disk.printDisk() == "0099811188827773336446555566..............")

        // observing how file IDs > 1 digit behave...
        let disk2 = SimpleDisk(diskMap: day.parse(sampleData2))
        print(disk2.printDisk())
        disk2.defrag()
        #expect(disk2.printDisk() == "00101091119882887333744755556666.................")
    }

    @Test func testDiskChecksum() async throws {
        let disk = SimpleDisk(diskMap: day.parse(sampleData))
        disk.defrag()
        #expect(disk.calculateChecksum() == 1928)
    }

    @Test func testPartOneWithSampleData() async throws {
        let answer = try #require(day.partOne(input: sampleData) as? Int)
        #expect(answer == 1928)
    }

    @Test func testPartOne() async throws {
        let answer = try await #require(day.run(part: 1) as? Int)
        #expect(answer == 6_398_252_054_886)
    }

    @Test func testDiskParsingBasicVsNew() async throws {
        let disk = SimpleDisk(diskMap: day.parse(sampleData))
        #expect(disk.printDisk() == "00...111...2...333.44.5555.6666.777.888899")
        #expect(disk.printDisk(basic: false) == "00...111...2...333.44.5555.6666.777.888899")

        let disk2 = SimpleDisk(diskMap: day.parse(day.defaultInput))
        #expect(disk2.printDisk(basic: true) == disk2.printDisk(basic: false))
    }

    @Test func testDiskWholeFileDefrag() async throws {
        let disk = SimpleDisk(diskMap: day.parse(sampleData))
        disk.wholeFileDefrag()
        #expect(disk.printDisk(basic: false) == "00992111777.44.333....5555.6666.....8888..")
        #expect(disk.calculateChecksum(basic: false) == 2858)
    }

    @Test func testPartTwoWithSampleData() async throws {
        let answer = try #require(day.partTwo(input: sampleData) as? Int)
        #expect(answer == 2858)
    }

    // excluded from running since it takes ~10 seconds
    @Test func testPartTwo() async throws {
        print(Date.now)
        let answer = try await #require(day.run(part: 2) as? Int)
        print(Date.now)
        #expect(answer == 6415666220005)
    }

}
