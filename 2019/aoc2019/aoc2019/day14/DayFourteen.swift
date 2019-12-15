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

    var oreCount: Int {
        requirements["ORE"] ?? 0
    }

    /// Prime the factory with the required amount of FUEL. Defaults to 1
    mutating func prime(count: Int = 1) {
        requirements["FUEL"] = count
    }

    /// Reset the factory. Clears out the leftovers and requirements.
    mutating func reset() {
        requirements.removeAll()
        leftovers.removeAll()
    }

    mutating func oreRequiredFor(fuel: Int) -> Int {
        reset()
        prime(count: fuel)

        repeat {
            process()
        } while !finished

        return oreCount
    }

    mutating func run() {
        repeat {
            process()
        } while !finished
    }

    mutating func process() {
        var reqs = requirements
        for req in requirements {
            guard let reaction = reactions[req.key] else { continue }
            var requiredQuantity = req.value // number of this element we need

            if let extra = leftovers[req.key], extra > 0 {
                if extra >= requiredQuantity {
                    leftovers[req.key] = (leftovers[req.key] ?? 0) - requiredQuantity
                    requiredQuantity -= requiredQuantity
                } else {
                    requiredQuantity -= extra
                    leftovers[req.key] = (leftovers[req.key] ?? 0) - extra
                }
            }

            var multiplier = requiredQuantity / reaction.quantity
            multiplier += (requiredQuantity % reaction.quantity == 0 ? 0 : 1)
            let amountMade = multiplier * reaction.quantity

            if requiredQuantity > 0 {
                // for each requirement determine how many inputs (and quantities) it needs
                for input in reaction.inputs {
                    var quantityNeeded = input.value * multiplier

                    if let extra = leftovers[input.key], extra > 0 {
                        if extra >= quantityNeeded {
                            // remove from the leftovers and skip since we found all we needed
                            leftovers[input.key] = (leftovers[input.key] ?? 0) - quantityNeeded
                            continue
                        } else {
                            // remove from the leftovers and continue since we need more
                            quantityNeeded -= extra
                            leftovers[input.key] = (leftovers[input.key] ?? 0) - extra
                        }
                    }

                    reqs[input.key] = (reqs[input.key] ?? 0) + quantityNeeded
                }
            }

            // if we made more of this than we needed, add it to the leftovers
            if amountMade > requiredQuantity {
                let extra = amountMade - requiredQuantity
                leftovers[reaction.output] = (leftovers[reaction.output] ?? 0) + extra
            }

            // clean up the initial quanitity of this element
            reqs[req.key] = (reqs[req.key] ?? 0) - req.value
        }

        // filter out any elements that we've satisified all needs of
        reqs = reqs.filter { $1 != 0 }

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
            factory.process()
        } while !factory.finished

        return factory.oreCount
    }

    func partTwo(input: String?) -> Any {

        let trillion = 1_000_000_000_000 // 1 trillion ore
        var answer: Int = 0
        var fuelMade = 0
        var oreCount = 0

        var factory = NanoFactory(input: input ?? "")

        while true {
            oreCount = factory.oreCount
            if (fuelMade % 100_000) == 0 {
                print("FUEL: \(fuelMade) -> \(oreCount)")
            }
            // print("FUEL: \(fuelMade) -> \(.oreCount)")

            if oreCount < trillion {
                fuelMade += 1
                factory.prime(count: 1)
                factory.run()
            } else {
                answer = fuelMade - 1 // made too much between last run so last was the max
                break
            }
        }

        return answer
    }
}
