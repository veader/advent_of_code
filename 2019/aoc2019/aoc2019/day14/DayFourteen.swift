//
//  DayFourteen.swift
//  aoc2019
//
//  Created by Shawn Veader on 12/14/19.
//  Copyright © 2019 Shawn Veader. All rights reserved.
//

import Foundation

struct NanoFactory {
    let reactions: [String: Reaction]
    var requirements: [String: Int]
    var leftovers: [String: Int]

    var finished: Bool {
        requirements.keys.count == 1
    }

    mutating func prime(count: Int = 1) {
        requirements["FUEL"] = count
    }

    mutating func process() {
        print("Start loop: \(requirements)")
        print("\tLeftovers: \(leftovers)")
        var reqs = requirements
        for req in requirements {
            guard let reaction = reactions[req.key] else { continue }
            var requiredQuantity = req.value // number of this element we need
            print("\(req.key) makes in quantities of \(reaction.quantity)")
            print("\tWe need \(requiredQuantity) of \(req.key)")

            if let extra = leftovers[req.key], extra > 0 {
                if extra >= requiredQuantity {
                    print("\t* We have ALL we need in leftovers, use those first")
                    leftovers[req.key] = (leftovers[req.key] ?? 0) - requiredQuantity
                    requiredQuantity -= requiredQuantity
                } else {
                    print("\t* We have SOME in leftovers, use those first")
                    requiredQuantity -= extra
                    leftovers[req.key] = (leftovers[req.key] ?? 0) - extra
                    print("\t* Now only need \(requiredQuantity)")
                }
            }

            var multiplier = requiredQuantity / reaction.quantity
            multiplier += (requiredQuantity % reaction.quantity == 0 ? 0 : 1)
            let amountMade = multiplier * reaction.quantity
            print("\tSo we have to make \(multiplier).. (\(amountMade))")

            if requiredQuantity > 0 {
                // for each requirement determine how many inputs (and quantities) it needs
                for input in reaction.inputs {
                    print("\t\t\(req.key) needs \(input.key) - \(input.value)")
                    var quantityNeeded = input.value * multiplier

                    if let extra = leftovers[input.key], extra > 0 {
                        if extra >= quantityNeeded {
                            print("\t\tFound ALL in leftovers of \(input.key)")
                            // remove from the leftovers and skip since we found all we needed
                            leftovers[input.key] = (leftovers[input.key] ?? 0) - quantityNeeded
                            continue
                        } else {
                            print("\t\tFound SOME in leftovers of \(input.key)")
                            // remove from the leftovers and continue since we need more
                            quantityNeeded -= extra
                            leftovers[input.key] = (leftovers[input.key] ?? 0) - extra
                        }

                        print("\t\tNow we only need \(quantityNeeded) of \(input.key)")
                    }

                    reqs[input.key] = (reqs[input.key] ?? 0) + quantityNeeded
                }
            }

            // if we made more of this than we needed, add it to the leftovers
            if amountMade > requiredQuantity {
                let extra = amountMade - requiredQuantity
                print("\t** We made extra... Leftover: \(extra)")
                leftovers[reaction.output] = (leftovers[reaction.output] ?? 0) + extra
            }

            // clean up the initial quanitity of this element
            reqs[req.key] = (reqs[req.key] ?? 0) - req.value
        }

        // filter out any elements that we've satisified all needs of
        reqs = reqs.filter { $1 != 0 }
        // TODO: clean out leftovers?

        print("End loop: \(reqs)")
        requirements = reqs
    }
}

extension NanoFactory {
    init(input: String) {
        requirements = [String: Int]()
        leftovers = [String: Int]()

        var reactionHash = [String: Reaction]()
        let reactionList = input.split(separator: "\n")
                                .compactMap(String.init)
                                .compactMap { Reaction.init(input: $0) }

        for reaction in reactionList {
            if reactionHash[reaction.output] != nil {
                // shouldn't happen but good to know...
                print("OH NO: Second reaction for \(reaction.output)")
            }
            reactionHash[reaction.output] = reaction
        }

        reactions = reactionHash
    }
}

struct DayFourteen: AdventDay {
    var dayNumber: Int = 14


    func partOne(input: String?) -> Any {
        var factory = NanoFactory(input: input ?? "")
        factory.prime()

        repeat {
            print("----------------------------------")
            factory.process()
        } while !factory.finished

        print("Finals...")
        print(factory.requirements)
        print(factory.leftovers)

        return factory.requirements["ORE"] ?? 0
    }

    func partTwo(input: String?) -> Any {
        return 0
    }
}
