//
//  DayTwentyTwo.swift
//  aoc2019
//
//  Created by Shawn Veader on 12/28/19.
//  Copyright © 2019 Shawn Veader. All rights reserved.
//

import Foundation

enum Deal {
    case newStack
    case cut(number: Int)
    case increment(number: Int)

    static func parse(_ input: String) -> Deal? {
        if input == "deal into new stack" {
            return .newStack
        } else if input.hasPrefix("cut") {
            if let amountStr = input.split(separator: " ").map(String.init).last, let amount = Int(amountStr) {
                return .cut(number: amount)
            }
        } else if input.hasPrefix("deal with increment") {
            if let amountStr = input.split(separator: " ").map(String.init).last, let amount = Int(amountStr) {
                return .increment(number: amount)
            }
        }

        return nil
    }
}

struct CardDeck {
    var cards: [Int]
    let size: Int

    init(size: Int) {
        self.size = size
        cards = Array(0..<size)
    }

    mutating func deal(_ dealType: Deal) {
        switch dealType {
        case .newStack:
            cards = cards.reversed()
        case .cut(number: let num):
            cards = cards.rotate(by: num)
        case .increment(number: let num):
            incremental(num)
        }
    }

    private mutating func incremental(_ num: Int) {
        var currentCards = cards
        var newCards = Array(repeating: 0, count: size)

        var index = 0
        while !currentCards.isEmpty {
            let card = currentCards.removeFirst()
            newCards[index] = card
            index = (index + num) % size
        }

        cards = newCards
    }

    static func indexReversing(deal: Deal, index: Int, size: Int) -> Int {
        switch deal {
        case .newStack:
            return (size - 1) - index
        case .cut(number: let num):
            var originalIndex = index + num

            // handle wrapping around the ends
            if originalIndex >= size {
                originalIndex = originalIndex - size
            } else if originalIndex < 0 {
                originalIndex = size + originalIndex
            }

            return originalIndex
        case .increment(number: let num):
            // increment 3
            // 0 1 2 3 4 5 6 7 8 9 <- original
            // 0 7 4 1 8 5 2 9 6 3 <- final
            // size % 3 = 1
            // 1st: 0, 3, 6, 9   <- 0,1,2,3
            // 2nd:    2, 5, 8   <- 4,5,6
            // 3rd:    1, 4, 7   <- 7,8,9

            // increment 7
            // 0 1 2 3 4 5 6 7 8 9 <- original
            // 0 3 6 9 2 5 8 1 4 7 <- final
            // size % 7 = 3
            // 1st: 0, 7            <- 0,1
            // 2nd:    4            <- 2
            // 3rd:    1, 8         <- 3,4
            // 4th:       5         <- 5
            // 5th:       2, 9      <- 6,7
            // 6th:          6      <- 8
            // 7th:          3      <- 9

            if index % num == 0 {
                return index / num
            }

            // TODO: optimization -> binary search of size for iteration?
            var iteration = 0 // ugly...
            while ((num * iteration) % size) != index {
                iteration += 1
            }

            return iteration
        }
    }
}

struct DayTwentyTwo: AdventDay {
    var dayNumber: Int = 22

    func parse(_ input: String?) -> [Deal] {
        return (input ?? "").split(separator: "\n")
                            .map(String.init)
                            .compactMap { Deal.parse($0) }
    }

    func partOne(input: String?) -> Any {
        let size = 10007
        let deals = parse(input ?? "")

        var deck = CardDeck(size: size)
        deals.forEach { deck.deal($0) }

        let answer = deck.cards.firstIndex(of: 2019)
        return answer ?? 0
    }

    func partTwo(input: String?) -> Any {
        let size = 119_315_717_514_047
        let deals = parse(input ?? "")
        let reversedDeals = deals.reversed()

        // run deals in reverse order
        // calculate from index 2020 at the end of the last iteration
        //      with each step, determine what index is used to populate it
        // iterate back until we get to the starting deck. the index should
        //      point to the value...
        var original = 2020

        print("Start: \(Date())")
        for i in 0..<101_741_582_076_661 {
            print("\tIteration \(i) : \(Date()) -> Index \(original)")
            for deal in reversedDeals {
                original = CardDeck.indexReversing(deal: deal, index: original, size: size)
            }
        }
        print("End: \(Date())")

        return original

//        print("Start: \(Date())")
//
//        var deck = CardDeck(size: size)
//        for i in (0..<101_741_582_076_661) {
//            print("\tStarting iteration \(i)... \(Date())")
//            deals.forEach { deck.deal($0) }
//        }
//
//        print("End: \(Date())")
//        return deck.cards[2020]
    }
}
