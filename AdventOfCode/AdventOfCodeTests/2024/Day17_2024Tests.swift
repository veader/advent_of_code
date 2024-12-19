//
//  Day17_2024Tests.swift
//  AdventOfCodeTests
//
//  Created by Shawn Veader on 12/19/24.
//

import Testing
import Foundation

struct Day17_2024Tests {
    let sampleData = """
        Register A: 729
        Register B: 0
        Register C: 0
        
        Program: 0,1,5,4,3,0
        """

    let sampleData2 = """
        Register A: 2024
        Register B: 0
        Register C: 0
        
        Program: 0,3,5,4,3,0
        """

    let day = Day17_2024()

    @Test func testComputerParsing() async throws {
        let computer = Chronoputer(input: sampleData)
        #expect(computer.registerA == 729)
        #expect(computer.registerB == 0)
        #expect(computer.registerC == 0)
        #expect(computer.instructions.count == 6)
    }

    @Test func testComputerComboOperands() async {
        let computer = Chronoputer(input: sampleData)
        computer.registerC = 42
        #expect(computer.comboValue(of: 0) == 0)
        #expect(computer.comboValue(of: 1) == 1)
        #expect(computer.comboValue(of: 2) == 2)
        #expect(computer.comboValue(of: 3) == 3)
        #expect(computer.comboValue(of: 4) == 729)
        #expect(computer.comboValue(of: 5) == 0)
        #expect(computer.comboValue(of: 6) == 42)
        #expect(computer.comboValue(of: 7) == nil)
        #expect(computer.comboValue(of: 8) == nil)
    }

    @Test func testSimpleComputes() async throws {
        let computer = Chronoputer(input: sampleData)

        // case 1
        computer.reset()
        #expect(computer.registerB == 0)
        computer.registerC = 9
        computer.instructions = [2,6]
        computer.execute()
        #expect(computer.registerB == 1)

        // case 2
        computer.reset()
        #expect(computer.output.isEmpty)
        computer.registerA = 10
        computer.instructions = [5,0,5,1,5,4]
        computer.execute()
        #expect(computer.output == [0,1,2])

        // case 3
        computer.reset()
        computer.registerA = 2024
        computer.instructions = [0,1,5,4,3,0]
        computer.execute()
        #expect(computer.output == [4,2,5,6,7,7,7,7,3,1,0])
        #expect(computer.registerA == 0)

        // case 4
        computer.reset()
        computer.registerB = 29
        computer.instructions = [1,7]
        computer.execute()
        #expect(computer.registerB == 26)

        // case 5
        computer.reset()
        computer.registerB = 2024
        computer.registerC = 43690
        computer.instructions = [4,0]
        computer.execute()
        #expect(computer.registerB == 44354)
    }

    @Test func testPartOneWithSampleData() async throws {
        let output = try await #require(day.partOne(input: sampleData) as? String)
        #expect(output == "4,6,3,5,6,3,5,2,1,0")
    }

    @Test func testPartOne() async throws {
        let answer = try await #require(day.run(part: 1) as? String)
        #expect(answer == "4,1,5,3,1,5,3,5,7")
    }

//    @Test func testPartTwoWithSampleData() async throws {
//        let output = try await #require(day.partTwo(input: sampleData2) as? Int)
//        #expect(output == 117440)
//    }
//
//    @Test func testPartTwo() async throws {
//        let answer = try await #require(day.run(part: 2) as? Int)
//        #expect(answer == 100)
//    }
}
