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

        deck = CardDeck(size: 10)
        deck.deal(.increment(number: 7))
        print(deck.cards)
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

    func testReversingNewStack0() {
        let index = 2
        let size = 10

        var deck = CardDeck(size: size)
        deck.deal(.newStack)
        let value = deck.cards[index]

        let originalIndex = CardDeck.indexReversing(deal: .newStack, index: index, size: size)
        XCTAssertEqual(value, originalIndex)
    }

    func testReversingNewStack1() {
        let index = 243
        let size = 555

        var deck = CardDeck(size: size)
        deck.deal(.newStack)
        let value = deck.cards[index]

        let originalIndex = CardDeck.indexReversing(deal: .newStack, index: index, size: size)
        XCTAssertEqual(value, originalIndex)
    }

    func testReversingCut0() {
        let index = 2
        let size = 10
        var deal: Deal = .cut(number: 3)

        var deck = CardDeck(size: size)
        deck.deal(deal)
        var value = deck.cards[index]

        var originalIndex = CardDeck.indexReversing(deal: deal, index: index, size: size)
        XCTAssertEqual(value, originalIndex)


        deal = .cut(number: -3)
        deck = CardDeck(size: size)
        deck.deal(deal)
        value = deck.cards[index]

        originalIndex = CardDeck.indexReversing(deal: deal, index: index, size: size)
        XCTAssertEqual(value, originalIndex)
    }

    func testReversingCut1() {
        let index = 243
        let size = 555
        var deal: Deal = .cut(number: 312)

        var deck = CardDeck(size: size)
        deck.deal(deal)
        var value = deck.cards[index]

        var originalIndex = CardDeck.indexReversing(deal: deal, index: index, size: size)
        XCTAssertEqual(value, originalIndex)


        deal = .cut(number: 313)
        deck = CardDeck(size: size)
        deck.deal(deal)
        value = deck.cards[index]

        originalIndex = CardDeck.indexReversing(deal: deal, index: index, size: size)
        XCTAssertEqual(value, originalIndex)


        deal = .cut(number: 311)
        deck = CardDeck(size: size)
        deck.deal(deal)
        value = deck.cards[index]

        originalIndex = CardDeck.indexReversing(deal: deal, index: index, size: size)
        XCTAssertEqual(value, originalIndex)
    }

    func testReverseIncrement0() {
        let index = 2
        let size = 10

        var deal: Deal = .increment(number: 3)
        var deck = CardDeck(size: size)
        deck.deal(deal)
        var value = deck.cards[index]

        var originalIndex = CardDeck.indexReversing(deal: deal, index: index, size: size)
        XCTAssertEqual(value, originalIndex)

        for idx in 0..<size {
            value = deck.cards[idx]
            originalIndex = CardDeck.indexReversing(deal: deal, index: idx, size: size)
            XCTAssertEqual(value, originalIndex)
        }


        deal = .increment(number: 7)
        deck = CardDeck(size: size)
        deck.deal(deal)

        for idx in 0..<size {
            value = deck.cards[idx]
            originalIndex = CardDeck.indexReversing(deal: deal, index: idx, size: size)
            XCTAssertEqual(value, originalIndex)
        }
    }

    func testReverseMultipleSteps() {
        let size = 10
        let day = DayTwentyTwo()
        let instructions = day.parse(testInput1)

        var deck = CardDeck(size: size)
        for deal in instructions {
            deck.deal(deal)
        }

        for idx in 0..<size {
            let value = deck.cards[idx]
            var original = idx
            for deal in instructions.reversed() {
                original = CardDeck.indexReversing(deal: deal, index: original, size: size)
            }
            XCTAssertEqual(value, original)
        }
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
