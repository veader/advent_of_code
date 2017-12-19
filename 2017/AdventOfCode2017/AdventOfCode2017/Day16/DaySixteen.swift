//
//  DaySixteen.swift
//  AdventOfCode2017
//
//  Created by Shawn Veader on 12/18/17.
//  Copyright © 2017 v8logic. All rights reserved.
//

import Foundation

struct DaySixteen: AdventDay {

    struct Dance {
        enum DanceMove {
            case spin(count: Int)
            case exchange(a: Int, b: Int)
            case partner(a: String, b: String)

            static func read(_ input: String) -> DanceMove? {
                guard input.count > 1 else { return nil }
                let prefix = input.prefix(1)
                let theReset = input.suffix(from: input.index(after: input.startIndex))

                switch prefix {
                case "s": // format: sX
                    guard let spinCount = Int(theReset) else { return nil }
                    return .spin(count: spinCount)
                case "x": // format: xA/B
                    let partners = theReset.split(separator: "/")
                                           .map { String($0).trimmed() }
                                           .flatMap(Int.init)// { Int($0) }
                    guard partners.count == 2 else { return nil }
                    return .exchange(a: partners[0], b: partners[1])
                case "p": // format: pA/B
                    let partners = theReset.split(separator: "/")
                        .map { String($0).trimmed() }
                    guard partners.count == 2 else { return nil }
                    return .partner(a: partners[0], b: partners[1])
                default:
                    return nil
                }
            }
        }

        var dancers = "abcdefghijklmnop".map(String.init)
        var steps: [DanceMove]

        init(_ input: String) {
            let stepInstructions = input.split(separator: ",").map { String($0).trimmed() }
            steps = stepInstructions.flatMap { DanceMove.read($0) }
        }

        mutating func perform(printing: Bool = false) {
            for (idx, step) in steps.enumerated() {
                if printing {
                    print("\(idx): \(dancers.joined())")
                }

                switch step {
                case .spin(let count):
                    let tail = dancers.suffix(count)
                    dancers.removeLast(count)
                    dancers = tail + dancers
                case .exchange(a: let aIndex, b: let bIndex):
                    let dancerA = dancers[aIndex]
                    let dancerB = dancers[bIndex]
                    dancers[aIndex] = dancerB
                    dancers[bIndex] = dancerA
                case .partner(a: let aName, b: let bName):
                    guard
                        let aIndex = dancers.index(of: aName),
                        let bIndex = dancers.index(of: bName)
                        else {
                            print("Could not find either \(aName) or \(bName)")
                            continue
                        }
                    dancers[aIndex] = bName
                    dancers[bIndex] = aName
                }
            }

            if printing {
                print("Fin: \(dancers.joined())")
            }
        }
    }

    // MARK: -

    func defaultInput() -> String? {
        let path = "\(dataPath())/day16input.txt"
        return try? String(contentsOfFile: path, encoding: .utf8)
    }

    func run(_ input: String? = nil) {
        guard let runInput = input ?? defaultInput() else {
            print("Day 16: 💥 NO INPUT")
            exit(10)
        }

        let thing = partOne(input: runInput)
        guard let answer = thing else {
            print("Day 16: (Part 1) 💥 Unable to calculate answer.")
            exit(1)
        }
        print("Day 16: (Part 1) Answer ", answer)

        // ...
    }

    // MARK: -

    func partOne(input: String) -> String? {
        var dance = Dance(input)
        dance.perform()

        return dance.dancers.joined()
    }

    func partTwo(input: String) -> Int? {
        return nil
    }
}

