//
//  Day8_2023Tests.swift
//  AdventOfCodeTests
//
//  Created by Shawn Veader on 12/8/23.
//

import XCTest

final class Day8_2023Tests: XCTestCase {

    let sampleInput = """
        RL

        AAA = (BBB, CCC)
        BBB = (DDD, EEE)
        CCC = (ZZZ, GGG)
        DDD = (DDD, DDD)
        EEE = (EEE, EEE)
        GGG = (GGG, GGG)
        ZZZ = (ZZZ, ZZZ)
        """

    let sampleInput2 = """
        LLR

        AAA = (BBB, BBB)
        BBB = (AAA, ZZZ)
        ZZZ = (ZZZ, ZZZ)
        """

    let sampleInput3 = """
        LR

        11A = (11B, XXX)
        11B = (XXX, 11Z)
        11Z = (11B, XXX)
        22A = (22B, XXX)
        22B = (22C, 22C)
        22C = (22Z, 22Z)
        22Z = (22B, 22B)
        XXX = (XXX, XXX)
        """

    func testWastelandNodeParsing() throws {
        let node = try XCTUnwrap(WastelandMap.WastelandNode("AAA = (BBB, CCC)"))
        XCTAssertEqual("AAA", node.name)
        XCTAssertEqual("BBB", node.pathLeft)
        XCTAssertEqual("BBB", node.node(to: .left))
        XCTAssertEqual("CCC", node.pathRight)
        XCTAssertEqual("CCC", node.node(to: .right))
    }

    func testWastelandMapParsing() throws {
        let wasteland = WastelandMap(sampleInput)

        XCTAssertEqual(2, wasteland.directions.count)
        XCTAssertEqual(WastelandMap.Direction.right, wasteland.directions.first)
        XCTAssertEqual(WastelandMap.Direction.left, wasteland.directions.last)

        XCTAssertEqual(7, wasteland.nodes.keys.count)

        print(wasteland)
        for node in wasteland.nodes.values {
            print(node)
        }
    }

    func testWastelandMapFollowingDirections() throws {
        let wasteland = WastelandMap(sampleInput)
        let answer = try wasteland.followDirections()
        XCTAssertEqual(2, answer)

        let wl2 = WastelandMap(sampleInput2)
        let a2 = try wl2.followDirections()
        XCTAssertEqual(6, a2)
    }

    func testPart1() async throws {
        let answer = await Day8_2023().run(part: 1, sampleInput)
        XCTAssertEqual(2, answer as? Int)
    }

    func testPart1Answer() async throws {
        let answer = await Day8_2023().run(part: 1)
        XCTAssertEqual(17873, answer as? Int)
    }

    func testWastelandStartNodes() throws {
        let wasteland = WastelandMap(sampleInput3)
        let starts = wasteland.startNodes().sorted()
        XCTAssertEqual(2, starts.count)
        XCTAssertEqual(["11A", "22A"], starts)
    }

    func testWastelandEndDetection() throws {
        let wasteland = WastelandMap(sampleInput3)
        XCTAssertTrue(wasteland.endInZed(nodes: ["11Z", "22Z"]))
        XCTAssertFalse(wasteland.endInZed(nodes: ["AAA", "ZZZ"]))
    }

    func testPart2() async throws {
        let answer = await Day8_2023().run(part: 2, sampleInput3)
        XCTAssertEqual(6, answer as? Int)
    }
}
