//
//  Day9_2024Tests.swift
//  AdventOfCodeTests
//
//  Created by Shawn Veader on 12/9/24.
//

import Testing

struct Day9_2024Tests {

    let sampleDataEasy = "12345"
    let sampleData = "2333133121414131402"

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
        #expect(answer == 6398252054886)
    }
}
