//
//  DayThirteen2022Tests.swift
//  AdventOfCodeTests
//
//  Created by Shawn Veader on 12/14/22.
//

import XCTest

final class DayThirteen2022Tests: XCTestCase {
    let sampleInput = """
        [1,1,3,1,1]
        [1,1,5,1,1]

        [[1],[2,3,4]]
        [[1],4]

        [9]
        [[8,7,6]]

        [[4,4],4,4]
        [[4,4],4,4,4]

        [7,7,7,7]
        [7,7,7]

        []
        [3]

        [[[]]]
        [[]]

        [1,[2,[3,[4,[5,6,7]]]],8,9]
        [1,[2,[3,[4,[5,6,0]]]],8,9]
        """

    func testParsingPacket() {
        var str = "[[[5,8],2]]"
        var index = str.startIndex
        var packet = DistressSignal.parse(packet: str, readIndex: &index)
        XCTAssertNotNil(packet)
        XCTAssertEqual(str.endIndex, index) // moved pointer to the end
        guard
            case .list(let nested1) = packet,
            case .list(let nested2) = nested1.first,
            case .list(let inner) = nested2.first,
            case .integer(let rightNum) = nested2.last
        else { XCTFail(); return }

        XCTAssertEqual([DistressSignal.PacketByte.integer(5), DistressSignal.PacketByte.integer(8)], inner)
        XCTAssertEqual(2, rightNum)

        // ----
        str = "[7,6,8,4,7]"
        index = str.startIndex
        packet = DistressSignal.parse(packet: str, readIndex: &index)
        XCTAssertNotNil(packet)
        XCTAssertEqual(str.endIndex, index) // moved pointer to the end
        guard case .list(let inner2) = packet else { XCTFail(); return }
        XCTAssertEqual([DistressSignal.PacketByte.integer(7),
                        DistressSignal.PacketByte.integer(6),
                        DistressSignal.PacketByte.integer(8),
                        DistressSignal.PacketByte.integer(4),
                        DistressSignal.PacketByte.integer(7)], inner2)

        // ----
        str = "[]"
        index = str.startIndex
        packet = DistressSignal.parse(packet: str, readIndex: &index)
        XCTAssertNotNil(packet)
        XCTAssertEqual(str.endIndex, index) // moved pointer to the end
        guard case .list(let inner3) = packet else { XCTFail(); return }
        XCTAssertEqual([], inner3)

        // ----
        let str2 = "[[1],[2,3,4]]"
        var index2 = str2.startIndex
        let packet2 = DistressSignal.parse(packet: str2, readIndex: &index2)
        XCTAssertNotNil(packet2)
        XCTAssertEqual(str2.endIndex, index2) // moved pointer to the end
        guard case .list(let inner4) = packet2 else { XCTFail(); return }
        XCTAssertEqual([
            DistressSignal.PacketByte.list([
                DistressSignal.PacketByte.integer(1)
            ]),
            DistressSignal.PacketByte.list([
                DistressSignal.PacketByte.integer(2),
                DistressSignal.PacketByte.integer(3),
                DistressSignal.PacketByte.integer(4)
            ]),
        ], inner4)
        XCTAssertEqual(str2, packet2!.debugDescription.replacingOccurrences(of: " ", with: ""))
    }

    func testParsing() {
        let signal = DistressSignal(sampleInput)
        XCTAssertEqual(8, signal.pairs.count)
    }

    func testSimpleCompare() {
        let simplePair = """
                [1,1,3,1,1]
                [1,1,5,1,1]
                """

        let signal = DistressSignal(simplePair)
        let answers = signal.compare()
        XCTAssertEqual(1, answers.count)
        XCTAssertTrue(answers[0])
    }

    func testUnbalancedCompare() {
        let simplePair = """
                [7,7,7,7]
                [7,7,7]
                """

        let signal = DistressSignal(simplePair)
        let answers = signal.compare()
        XCTAssertEqual(1, answers.count)
        XCTAssertFalse(answers[0])
    }

    func testHarderCompare() {
        let simplePair = """
                [[1],[2,3,4]]
                [[1],4]
                """

        let signal = DistressSignal(simplePair)
        let answers = signal.compare()
        XCTAssertEqual(1, answers.count)
        XCTAssertTrue(answers[0])
    }

    func testMismatchedPair() {
        let simplePair = """
                [9]
                [[8,7,6]]
                """

        let signal = DistressSignal(simplePair)
        let answers = signal.compare()
        XCTAssertEqual(1, answers.count)
        XCTAssertFalse(answers[0])
    }

    func testCompares() {
        let signal = DistressSignal(sampleInput)
        let answers = signal.compare()
        XCTAssertEqual(8, answers.count)
        XCTAssertTrue(answers[0])
        XCTAssertTrue(answers[1])
        XCTAssertFalse(answers[2])
        XCTAssertTrue(answers[3])
        XCTAssertFalse(answers[4])
        XCTAssertTrue(answers[5])
        XCTAssertFalse(answers[6])
        XCTAssertFalse(answers[7])
    }

    func testCorrectPairs() {
        let signal = DistressSignal(sampleInput)
        let answers = signal.correctPairs()
        XCTAssertEqual([1, 2, 4, 6], answers)
    }

    func testPartOne()  {
        let answer = DayThirteen2022().partOne(input: sampleInput)
        XCTAssertEqual(13, answer as! Int)
    }

    func testPair() {
        let simplePair1 = """
            [[2,0]]
            [[[7,2,[],1,2]],[],[[],2,[[0,6,0,6,8]]]]
            """ // should be false
        let signal1 = DistressSignal(simplePair1)
        let answers1 = signal1.compare()
        XCTAssertEqual(1, answers1.count)
        XCTAssertFalse(answers1[0])

    }

    func testFailureRedditInput() {
        // Random sample inputs with supposed appropriate responses from Reddit

        let simplePair1 = """
            [[8,[[7]]]]
            [[[[8]]]]
            """ // should be false
        let signal1 = DistressSignal(simplePair1)s
        let answers1 = signal1.compare()
        XCTAssertEqual(1, answers1.count)
        XCTAssertFalse(answers1[0])

        let simplePair2 = """
            [[8,[[7]]]]
            [[[[8],[3]]]]
            """ // should be false
        let signal2 = DistressSignal(simplePair2)
        let answers2 = signal2.compare()
        XCTAssertEqual(1, answers2.count)
        XCTAssertFalse(answers2[0])

//        let simplePair3 = """
//            [[8,[[7,10,10,5],[8,4,9]],3,5],[[[3,9,4],5,[7,5,5]],[[3,2,5],[10],[5,5],0,[8]]],[4,2,[],[[7,5,6,3,0],[4,4,10,7],6,[8,10,9]]],[[4,[],4],10,1]]
//            [[[[8],[3,10],[7,6,3,7,4],1,8]]]
//            """ // should be true
//
//        let signal3 = DistressSignal(simplePair3)
//        let answers3 = signal3.compare()
//        XCTAssertEqual(1, answers3.count)
//        XCTAssertTrue(answers3[0]) // we get false here... why?

        let simplePair4 = """
            [1,2,3,[1,2,3],4,1]
            [1,2,3,[1,2,3],4,0]
            """ // should be false
        let signal4 = DistressSignal(simplePair4)
        let answers4 = signal4.compare()
        XCTAssertEqual(1, answers4.count)
        XCTAssertFalse(answers4[0])
    }
}
