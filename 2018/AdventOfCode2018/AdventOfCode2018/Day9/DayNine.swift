//
//  DayNine.swift
//  AdventOfCode2018
//
//  Created by Shawn Veader on 12/9/18.
//  Copyright © 2018 Shawn Veader. All rights reserved.
//

import Foundation

class MarbleNode: Equatable {
    var next: MarbleNode?
    weak var previous: MarbleNode?

    let value: Int

    init(value: Int) {
        self.value = value
    }

    static func == (lhs: MarbleNode, rhs: MarbleNode) -> Bool {
        return lhs.value == rhs.value
    }

}

class MarbleCircle: CustomDebugStringConvertible {
    var start: MarbleNode
    weak var current: MarbleNode?
    var count: Int

    init() {
        let firstNode = MarbleNode(value: 0)
        firstNode.next = firstNode
        firstNode.previous = firstNode
        start = firstNode
        current = firstNode
        count = 1
    }

    func insert(marble: Int) {
        let newMarble = MarbleNode(value: marble)
        let preMarble = current?.next
        let postMarble = preMarble?.next

        preMarble?.next = newMarble
        newMarble.previous = preMarble

        postMarble?.previous = newMarble
        newMarble.next = postMarble

        current = newMarble
        count += 1
    }

    func removeMarble() -> Int {
        var removingMarble = current!
        var backCount = 0
        repeat {
            removingMarble = removingMarble.previous!
            backCount += 1
        } while backCount < 7

        let preMarble = removingMarble.previous
        let postMarble = removingMarble.next

        preMarble?.next = postMarble
        postMarble?.previous = preMarble

        current = postMarble
        count -= 1

        return removingMarble.value
    }

    var array: [Int] {
        guard count > 1 else { return [0] }

        var output = [Int]()

        var m = start
        repeat {
            output.append(m.value)
            m = m.next!
        } while m != start

        return output
    }

    var debugDescription: String {
        var output = ""

        guard count > 1 else { return "(0)" }

        var printMarble = start
        repeat {
            if printMarble == current {
                output += "(\(printMarble.value)) "
            } else {
                output += "\(printMarble.value) "
            }
            printMarble = printMarble.next!
        } while printMarble != start

        return output
    }
}

struct DayNine: AdventDay {
    var dayNumber: Int = 9

    @discardableResult func run(_ input: String? = nil, _ part: Int? = 1) -> Any {
         if part == 1 {
             let answer = partOne()
             print("Day \(dayNumber) Part \(part!): Final Answer \(answer)")
             return answer
         } else {
            let answer = partTwo()
            print("Day \(dayNumber) Part \(part!): Final Answer \(answer)")
            return answer
         }
    }

     func partOne() -> Int {
        return play(players: 468, until: 71010)
     }

     func partTwo() -> Int {
        return play(players: 468, until: 71010 * 100)
     }

    func play(players: Int, until lastMarble: Int) -> Int {
        let circle = MarbleCircle()
        var currentMarble = 1
        var scores = [Int: Int]()

        while currentMarble < lastMarble {
            for player in (0..<players) {
                if currentMarble % 23 == 0 {
                    let removed = circle.removeMarble()

                    scores[player] = (scores[player] ?? 0) + currentMarble + removed
//                    print(" ----------   Player \(player+1) plays \(currentMarble)")
//                    print(scores)
//                    print("\n")
                } else {
                    circle.insert(marble: currentMarble)
                }

                currentMarble += 1
                if currentMarble > lastMarble {
                    break
                }
            }
        }

//        print(circle)
//        print(scores)
        return scores.max(by: { $0.value < $1.value })?.value ?? Int.min
    }
}
