//
//  DayTwo2022Tests.swift
//  AdventOfCodeTests
//
//  Created by Shawn Veader on 12/2/22.
//

import XCTest

final class DayTwo2022Tests: XCTestCase {

    let sampleInput = """
        A Y
        B X
        C Z
        """

    func testParsing() {
        let output = DayTwo2022().parse(sampleInput)

        XCTAssertEqual(3, output.count)

        let firstHand = output.first!
        XCTAssertEqual(RoshamboRound.Hand.rock, firstHand.player1Hand)
        XCTAssertEqual(RoshamboRound.Hand.paper, firstHand.player2Hand)

        let secondHand = output[1]
        XCTAssertEqual(RoshamboRound.Hand.paper, secondHand.player1Hand)
        XCTAssertEqual(RoshamboRound.Hand.rock, secondHand.player2Hand)

        let thirdHand = output.last!
        XCTAssertEqual(RoshamboRound.Hand.scissor, thirdHand.player1Hand)
        XCTAssertEqual(RoshamboRound.Hand.scissor, thirdHand.player2Hand)
    }

    func testScoring() {
        let output = DayTwo2022().parse(sampleInput)

        XCTAssertEqual(8, output[0].scoreRound())
        XCTAssertEqual(1, output[1].scoreRound())
        XCTAssertEqual(6, output[2].scoreRound())
    }

    func testCalculating() {
        let output = DayTwo2022().parse(sampleInput)

        XCTAssertEqual(4, output[0].scoreCalculatedRound())
        XCTAssertEqual(1, output[1].scoreCalculatedRound())
        XCTAssertEqual(7, output[2].scoreCalculatedRound())
    }

    func testFirstStar() {
        let day = DayTwo2022()
        let score = day.partOne(input: sampleInput)

        XCTAssertEqual(15, score as! Int)
    }
}
