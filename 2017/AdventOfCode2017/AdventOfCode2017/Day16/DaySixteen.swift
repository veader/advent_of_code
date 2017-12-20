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

        var dancers: [String]
        var initialDancersState: [String]
        var steps: [DanceMove]

        var dancersString: String {
            return dancers.joined()
        }

        init(_ input: String) {
            initialDancersState = "abcdefghijklmnop".map(String.init)
            dancers = initialDancersState
            let stepInstructions = input.split(separator: ",").map { String($0).trimmed() }
            steps = stepInstructions.flatMap { DanceMove.read($0) }
        }

        mutating func perform(steps theSteps: [DanceMove]? = nil, printing: Bool = false) {
            dancers = perform(steps: steps, with: dancers, printing: printing)

            if printing {
                print("Fin: \(dancers.joined())")
            }
        }

        func perform(steps theSteps: [DanceMove]? = nil, with theDancers: [String], printing: Bool = false) -> [String] {
            let stepsToFollow = theSteps ?? steps
            var workingDancers = theDancers

            for (idx, step) in stepsToFollow.enumerated() {
                if printing {
                    print("\(idx): \(workingDancers.joined())")
                }

                workingDancers = perform(step: step, with: workingDancers)
            }


            return workingDancers
        }

        func perform(step: DanceMove, with theDancers: [String]) -> [String] {
            var workingDancers = theDancers

            switch step {
            case .spin(let count):
                let tail = workingDancers.suffix(count)
                workingDancers.removeLast(count)
                workingDancers = tail + workingDancers
            case .exchange(a: let aIndex, b: let bIndex):
                let dancerA = workingDancers[aIndex]
                let dancerB = workingDancers[bIndex]
                workingDancers[aIndex] = dancerB
                workingDancers[bIndex] = dancerA
            case .partner(a: let aName, b: let bName):
                if let aIndex = workingDancers.index(of: aName),
                   let bIndex = workingDancers.index(of: bName) {

                    workingDancers[aIndex] = bName
                    workingDancers[bIndex] = aName
                } else {
                    print("Could not find either \(aName) or \(bName)")
                }
            }

            return workingDancers
        }

        func calculateSteps() -> [DanceMove]? {
            var workingDancers = initialDancersState
            guard workingDancers.count == dancers.count else { return nil }

            // convert abcdefghijklmnop
            //    into bkgcdefiholnpmja
            return (0..<dancers.count).flatMap { idx -> DanceMove? in
                let currentLetter = dancers[idx]
                guard let startingIndex = workingDancers.index(of: currentLetter) else { return nil }

                // if the letter moved, create a step
                if idx != startingIndex {
                    let step = DanceMove.exchange(a: startingIndex, b: idx)
                    // now run this step on our working dancers to shift them accordingly
                    workingDancers = perform(step: step, with: workingDancers)
                    return step
                } else {
                    return nil
                }
            }
        }

        mutating func simpleRecital(count: Int, printing: Bool = false) {
            for i in (0..<count) {
                if printing {
                    print("Run \(i)")
                }

                perform(printing: printing)
            }
        }

        mutating func recital(count: Int, printing: Bool = false) {
            // perform dance once. calculate end dance (shorten dance)
            perform(printing: printing)

            guard let shortenedSteps = calculateSteps() else {
                print("Unable to calculate steps...")
                return
            }

            // then finish the number of dances
            for i in (1..<count) {
                if printing {
                    print("Run \(i)")
                }

                dancers = perform(steps: shortenedSteps, with: dancers, printing: printing)
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

        let thing2 = partTwo(input: runInput)
        guard let answer2 = thing2 else {
            print("Day 16: (Part 2) 💥 Unable to calculate answer.")
            exit(1)
        }
        print("Day 16: (Part 2) Answer ", answer2)
    }

    // MARK: -

    func partOne(input: String) -> String? {
        var dance = Dance(input)
        dance.perform()

        return dance.dancers.joined()
    }

    func partTwo(input: String) -> String? {
        var dance = Dance(input)
        dance.recital(count: 1_000_000_000) // 1 Billion Times (tm)

        return dance.dancers.joined()
    }
}

