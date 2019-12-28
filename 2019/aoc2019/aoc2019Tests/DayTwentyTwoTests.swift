//
//  DayTwentyTwoTests.swift
//  aoc2019Tests
//
//  Created by Shawn Veader on 12/28/19.
//  Copyright © 2019 Shawn Veader. All rights reserved.
//

import XCTest

class DayTwentyTwoTests: XCTestCase {

    func testDealIntoNewStackShuffle() {
        let initial = [0,1,2,3,4,5,6,7,8,9]

        var deck = CardDeck(size: 10)
        XCTAssertEqual(initial, deck.cards)

        deck.deal(.newStack)
        XCTAssertEqual([9,8,7,6,5,4,3,2,1,0], deck.cards)

        deck.deal(.newStack)
        XCTAssertEqual(initial, deck.cards)
    }

    func testDealCutNCards() {
        let initial = [0,1,2,3,4,5,6,7,8,9]

        var deck = CardDeck(size: 10)
        XCTAssertEqual(initial, deck.cards)

        deck.deal(.cut(number: 3))
        XCTAssertEqual([3,4,5,6,7,8,9,0,1,2], deck.cards)

        deck = CardDeck(size: 10)
        XCTAssertEqual(initial, deck.cards)

        deck.deal(.cut(number: -4))
        XCTAssertEqual([6,7,8,9,0,1,2,3,4,5], deck.cards)
    }

    func testDealIncrement() {
        var deck = CardDeck(size: 10)
        XCTAssertEqual([0,1,2,3,4,5,6,7,8,9], deck.cards)

        deck.deal(.increment(number: 3))
        XCTAssertEqual([0,7,4,1,8,5,2,9,6,3], deck.cards)
    }

    func testPartOnePieces() {
        var deck: CardDeck

        deck = CardDeck(size: 10)
        deck.deal(.increment(number: 7))
        deck.deal(.newStack)
        deck.deal(.newStack)
        XCTAssertEqual([0,3,6,9,2,5,8,1,4,7], deck.cards)

        deck = CardDeck(size: 10)
        deck.deal(.cut(number: 6))
        deck.deal(.increment(number: 7))
        deck.deal(.newStack)
        XCTAssertEqual([3,0,7,4,1,8,5,2,9,6], deck.cards)

        deck = CardDeck(size: 10)
        deck.deal(.increment(number: 7))
        deck.deal(.increment(number: 9))
        deck.deal(.cut(number: -2))
        XCTAssertEqual([6,3,0,7,4,1,8,5,2,9], deck.cards)

        deck = CardDeck(size: 10)
        deck.deal(.newStack)
        deck.deal(.cut(number: -2))
        deck.deal(.increment(number: 7))
        deck.deal(.cut(number: 8))
        deck.deal(.cut(number: -4))
        deck.deal(.increment(number: 7))
        deck.deal(.cut(number: 3))
        deck.deal(.increment(number: 9))
        deck.deal(.increment(number: 3))
        deck.deal(.cut(number: -1))
        XCTAssertEqual(testInput1Answer, deck.cards)
    }

    func testPartOneParsing() {
        let day = DayTwentyTwo()
        let instructions = day.parse(testInput1)

        var deck = CardDeck(size: 10)
        for deal in instructions {
            deck.deal(deal)
        }
        XCTAssertEqual(testInput1Answer, deck.cards)
    }

    let testInput1 = """
                     deal into new stack
                     cut -2
                     deal with increment 7
                     cut 8
                     cut -4
                     deal with increment 7
                     cut 3
                     deal with increment 9
                     deal with increment 3
                     cut -1
                     """
    let testInput1Answer = [9,2,5,8,1,4,7,0,3,6]
}
