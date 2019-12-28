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
        return 0
    }
}
