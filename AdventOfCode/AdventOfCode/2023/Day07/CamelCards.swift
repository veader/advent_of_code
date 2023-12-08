//
//  CamelCards.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/7/23.
//

import Foundation

struct CamelCards {
    typealias CamelCardRound = (hand: Hand, bid: Int)
    let rounds: [CamelCardRound]

    var sortedRounds: [CamelCardRound] {
        rounds.sorted(by: { $0.hand < $1.hand })
    }

    static func parse(_ input: String, useJokers: Bool = false) -> CamelCards {
        let rounds: [CamelCardRound] = input.split(separator: "\n").map(String.init).compactMap { line -> CamelCardRound? in
            let parts = line.split(separator: " ").map(String.init)
            guard parts.count == 2, let hand = Hand.parse(parts[0], useJokers: useJokers), let bid = Int(parts[1]) else { return nil }
            return (hand, bid)
        }

        return CamelCards(rounds: rounds)
    }
}

extension CamelCards {
    enum CamelCard: String {
        case two = "2"
        case three = "3"
        case four = "4"
        case five = "5"
        case six = "6"
        case seven = "7"
        case eight = "8"
        case nine = "9"
        case T
        case J
        case Q
        case K
        case A

        func weight(_ useJokers: Bool = false) -> Int {
            switch self {
            case .two:
                2
            case .three:
                3
            case .four:
                4
            case .five:
                5
            case .six:
                6
            case .seven:
                7
            case .eight:
                8
            case .nine:
                9
            case .T:
                10
            case .J:
                useJokers ? 1 : 11
            case .Q:
                12
            case .K:
                13
            case .A:
                14
            }
        }
    }

    enum HandKind: Int, Comparable {
        case fiveOfKind = 7
        case fourOfKind = 6
        case fullHouse = 5
        case threeOfKind = 4
        case twoPair = 3
        case onePair = 2
        case highCard = 1

        var name: String {
            switch self {
            case .fiveOfKind:
                return "5oK"
            case .fourOfKind:
                return "4oK"
            case .fullHouse:
                return "FH"
            case .threeOfKind:
                return "3oK"
            case .twoPair:
                return "2P"
            case .onePair:
                return "1P"
            case .highCard:
                return "HC"
            }
        }

        static func < (lhs: CamelCards.HandKind, rhs: CamelCards.HandKind) -> Bool {
            lhs.rawValue < rhs.rawValue
        }
    }

    struct Hand: Comparable, CustomDebugStringConvertible {
        let cards: [CamelCard]
        let kind: HandKind
        let jokersWild: Bool

        var debugDescription: String {
            "Hand(\(cards.map(\.rawValue).joined()) - \(kind.name))"
        }

        static func parse(_ input: String, useJokers: Bool = false) -> Hand? {
            let cards = input.split(separator: "").map(String.init).compactMap { CamelCard(rawValue: $0) }
            guard cards.count == 5 else { return nil }
            return Hand(cards: cards, kind: calculate(cards, useJokers: useJokers), jokersWild: useJokers)
        }

        static func calculate(_ cards: [CamelCard], useJokers: Bool = false) -> HandKind {
            var counts: [CamelCard: Int] = [:]
            for card in cards {
                counts[card] = (counts[card] ?? 0) + 1
            }

            let highCount = counts.values.max() ?? 1
            let uniqueCards = counts.keys.count

            // if we are NOT using jokers or the hand has no jokers, use the normal flow...
            if !useJokers || (counts[.J] ?? 0) == 0 {
                if highCount == 5 {
                    return .fiveOfKind
                } else if highCount == 4 {
                    return .fourOfKind
                } else if highCount == 3, uniqueCards == 2 {
                    return .fullHouse
                } else if highCount == 3, uniqueCards == 3 {
                    return .threeOfKind
                } else if highCount == 2, uniqueCards == 3 {
                    return .twoPair
                } else if highCount == 2, uniqueCards == 4 {
                    return .onePair
                } else {
                    return .highCard
                }
            } else {
                // mix jokers into this...
                let normalKind = calculate(cards, useJokers: false) // see what we would have been
                let jokerCount = counts[.J] ?? 0

                switch normalKind {
                case .fiveOfKind:
                    return .fiveOfKind // can't improve on this
                case .fourOfKind:
                    // 4 jokers + 1 other or 4 others + 1 joker = 5oK
                    return .fiveOfKind
                case .fullHouse:
                    // either of the 3 or 2 portions of a full house are jokers makes this a 5oK
                    return .fiveOfKind
                case .threeOfKind:
                    // jokers can either be the 3 matching cards or one of the other ones resulting in 4oK
                    return .fourOfKind
                case .twoPair:
                    if jokerCount == 1 {
                        // joker is the non-paired card, add it to one pair to make full house
                        return .fullHouse
                    } else if jokerCount == 2 {
                        // jokers are one of the pairs, add to other pair to make 4oK
                        return .fourOfKind
                    } else { // not sure what this is...
                        print("💥 #2 What is this?!? \(cards) (w/joker)")
                    }
                case .onePair:
                    // joker(s) can be the pair or one of the other cards but result in 3oK
                    return .threeOfKind
                case .highCard:
                    return .onePair
                }

                return normalKind // default to non-joker value?
            }
        }

        static func < (lhs: CamelCards.Hand, rhs: CamelCards.Hand) -> Bool {
            if lhs.kind != rhs.kind {
                return lhs.kind < rhs.kind
            } else {
                let idx = (0...4).first(where: { lhs.cards[$0].weight(lhs.jokersWild) != rhs.cards[$0].weight(rhs.jokersWild) })
                guard let idx else { return false }
                
                return lhs.cards[idx].weight(lhs.jokersWild) < rhs.cards[idx].weight(rhs.jokersWild)
            }
        }
    }
}
