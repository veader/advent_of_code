//
//  DayFourteen.swift
//  aoc2019
//
//  Created by Shawn Veader on 12/14/19.
//  Copyright © 2019 Shawn Veader. All rights reserved.
//

import Foundation

struct Reaction {
    let inputs: [String: Int]
    let output: String
    let quantity: Int

    typealias ParserResponse = (quantity: Int, name: String)
    private static let parser: (String) -> ParserResponse? = { input -> ParserResponse? in
        let pieces = input.trimmingCharacters(in: .symbols)
            .split(separator: " ")
            .compactMap(String.init)
        guard
            pieces.count == 2,
            let quantity = Int(pieces[0])
            else { print("Parser Pieces: \(pieces)"); return nil }

        return (quantity, pieces[1])
    }

    init?(input: String) {
        // format: 12 HKGWZ, 1 GPVTF, 8 PSHF => 9 QDVJ
        let pieces = input.split(separator: "=").compactMap(String.init)

        guard
            pieces.count == 2,
            let outputResponse = Reaction.parser(pieces[1])
            else { print("Pieces: \(pieces)"); return nil }

        output = outputResponse.name
        quantity = outputResponse.quantity

        let rawInputs = pieces[0]
                            .split(separator: ",")
                            .compactMap(String.init)
                            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }

        var tmpInputs = [String: Int]()
        rawInputs.forEach { input in
            if let response = Reaction.parser(input) {
                tmpInputs[response.name] = response.quantity
            }
        }
        inputs = tmpInputs
    }
}

struct DayFourteen: AdventDay {
    var dayNumber: Int = 14

    func parse(_ input: String?) -> [String: Reaction] {
        var reactionHash = [String: Reaction]()
        let reactions = (input ?? "")
                            .split(separator: "\n")
                            .compactMap(String.init)
                            .compactMap { Reaction.init(input: $0) }

        reactions.forEach { reaction in
            if reactionHash[reaction.output] != nil {
                // shouldn't happen but good to know...
                print("OH NO: Second reaction for \(reaction.output)")
            }
            reactionHash[reaction.output] = reaction
        }
        return reactionHash
    }

    func gatheringLoop(reactions: [String: Reaction], requirements: [String: Int]) -> [String: Int] {
        print("Start loop: \(requirements)")
        var reqs = requirements
        for req in requirements {
            // for each requirement determine how many inputs (and quantities) it needs
            guard let reaction = reactions[req.key] else { continue }
            let quantity = req.value // number of this element we need
            for input in reaction.inputs {
                var needed = req.value / reaction.quantity
                let remainder = req.value % reaction.quantity
                needed += (remainder == 0 ? 0 : 1)
                let quantityNeeded = needed * input.value

                reqs[input.key] = (reqs[input.key] ?? 0) + quantityNeeded
            }

            // clean up the initial quanitity of this element
            //   - being paranoid in case we loop around to this element again while making it?
            reqs[req.key] = (reqs[req.key] ?? 0) - quantity
        }

        // filter out any elements that we've satisified all needs of
        reqs = reqs.filter { $1 > 0 }

        print("End loop: \(reqs)")

        return reqs
    }

    func partOne(input: String?) -> Any {
        let reactions = parse(input)
        var reqs: [String: Int] = [String: Int]()
        reqs["FUEL"] = 1

        repeat {
            print("----------------------------------")
            reqs = gatheringLoop(reactions: reactions, requirements: reqs)
        } while reqs.keys.count > 1

        return reqs["ORE"] ?? 0
    }

    func partTwo(input: String?) -> Any {
        return 0
    }
}
