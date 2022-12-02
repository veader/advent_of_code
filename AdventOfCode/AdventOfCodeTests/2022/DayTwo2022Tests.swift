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
        XCTAssertEqual(DayTwo2022.RoshamboRound.Hand.rock, firstHand.player1Hand)
        XCTAssertEqual(DayTwo2022.RoshamboRound.Hand.paper, firstHand.player2Hand)

        let secondHand = output[1]
        XCTAssertEqual(DayTwo2022.RoshamboRound.Hand.paper, secondHand.player1Hand)
        XCTAssertEqual(DayTwo2022.RoshamboRound.Hand.rock, secondHand.player2Hand)

        let thirdHand = output.last!
        XCTAssertEqual(DayTwo2022.RoshamboRound.Hand.scissor, thirdHand.player1Hand)
        XCTAssertEqual(DayTwo2022.RoshamboRound.Hand.scissor, thirdHand.player2Hand)
    }

    func testScoring() {
        let output = DayTwo2022().parse(sampleInput)

        XCTAssertEqual(8, output[0].scoreRound())
        XCTAssertEqual(1, output[1].scoreRound())
        XCTAssertEqual(6, output[2].scoreRound())
    }

    func testFirstStar() {
        let day = DayTwo2022()
        let score = day.partOne(input: sampleInput)

        XCTAssertEqual(15, score as! Int)
    }
}
