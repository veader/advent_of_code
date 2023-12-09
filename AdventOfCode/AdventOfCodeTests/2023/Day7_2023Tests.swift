//
//  Day7_2023Tests.swift
//  AdventOfCodeTests
//
//  Created by Shawn Veader on 12/7/23.
//

import XCTest

final class Day7_2023Tests: XCTestCase {

    let sampleInput = """
        32T3K 765
        T55J5 684
        KK677 28
        KTJJT 220
        QQQJA 483
        """

    func testHandKindDetection() throws {
        var hand = try XCTUnwrap(CamelCards.Hand.parse("AAAAA"))
        XCTAssertEqual(CamelCards.HandKind.fiveOfKind, hand.kind)

        hand = try XCTUnwrap(CamelCards.Hand.parse("AA8AA"))
        XCTAssertEqual(CamelCards.HandKind.fourOfKind, hand.kind)

        hand = try XCTUnwrap(CamelCards.Hand.parse("23332"))
        XCTAssertEqual(CamelCards.HandKind.fullHouse, hand.kind)

        hand = try XCTUnwrap(CamelCards.Hand.parse("TTT98"))
        XCTAssertEqual(CamelCards.HandKind.threeOfKind, hand.kind)

        hand = try XCTUnwrap(CamelCards.Hand.parse("23432"))
        XCTAssertEqual(CamelCards.HandKind.twoPair, hand.kind)

        hand = try XCTUnwrap(CamelCards.Hand.parse("A23A4"))
        XCTAssertEqual(CamelCards.HandKind.onePair, hand.kind)

        hand = try XCTUnwrap(CamelCards.Hand.parse("23456"))
        XCTAssertEqual(CamelCards.HandKind.highCard, hand.kind)
    }

    func testHandKindDetectionWithJokers() throws {
        var hand = try XCTUnwrap(CamelCards.Hand.parse("AAAAA", useJokers: true))
        XCTAssertEqual(CamelCards.HandKind.fiveOfKind, hand.kind)

        hand = try XCTUnwrap(CamelCards.Hand.parse("32T3K", useJokers: true))
        XCTAssertEqual(CamelCards.HandKind.onePair, hand.kind)

        hand = try XCTUnwrap(CamelCards.Hand.parse("KK677", useJokers: true))
        XCTAssertEqual(CamelCards.HandKind.twoPair, hand.kind)

        hand = try XCTUnwrap(CamelCards.Hand.parse("T55J5", useJokers: true))
        XCTAssertEqual(CamelCards.HandKind.fourOfKind, hand.kind)
        
        hand = try XCTUnwrap(CamelCards.Hand.parse("KTJJT", useJokers: true))
        XCTAssertEqual(CamelCards.HandKind.fourOfKind, hand.kind)
        
        hand = try XCTUnwrap(CamelCards.Hand.parse("QQQJA", useJokers: true))
        XCTAssertEqual(CamelCards.HandKind.fourOfKind, hand.kind)
    }

    func testHandComparisons() throws {
        let hand1 = try XCTUnwrap(CamelCards.Hand.parse("33332"))
        let hand2 = try XCTUnwrap(CamelCards.Hand.parse("2AAAA"))

        XCTAssertTrue(hand1 > hand2)

        let hand3 = try XCTUnwrap(CamelCards.Hand.parse("77888"))
        let hand4 = try XCTUnwrap(CamelCards.Hand.parse("77788"))

        XCTAssertTrue(hand3 > hand4)
    }

    func testCamelCardsParsing() throws {
        let cards = CamelCards.parse(sampleInput)
        XCTAssertEqual(cards.rounds.count, 5)
        XCTAssertEqual(cards.rounds.first?.bid, 765)
    }

//    func testCamelCardsSorting() throws {
//        let cards = CamelCards.parse(sampleInput)
//        let sorted = cards.sortedRounds
//        for (idx, card) in sorted.enumerated() {
//            print("\(idx + 1): \(card)")
//        }
//    }

    func testPart1() throws {
        let answer = Day7_2023().run(part: 1, sampleInput)
        XCTAssertEqual(6440, answer as? Int)
    }

    func testPart1Answer() throws {
        let answer = Day7_2023().run(part: 1)
        XCTAssertEqual(250254244, answer as? Int)
    }

//    func testCamelCardSortingWithJokers() throws {
//        let cards = CamelCards.parse(sampleInput, useJokers: true)
//        let sorted = cards.sortedRounds
//        for (idx, card) in sorted.enumerated() {
//            print("\(idx + 1): \(card)")
//        }
//    }

    func testPart2() throws {
        let answer = Day7_2023().run(part: 2, sampleInput)
        XCTAssertEqual(5905, answer as? Int)
    }

    func testPart2Answser() throws {
        let answer = Day7_2023().run(part: 2)
        XCTAssertEqual(250087440, answer as? Int)
    }
}
